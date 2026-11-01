# Varför ett enda skapande ger ett beslutsdokument på 4 MB

Det är det nuvarande kontraktet för fullständig sluttillståndsevidens som gör dokumentet stort, inte storleken på den nya entiteten. Ett skapande från 8 192 levande entiteter ger **4 085 191 byte** kanonisk JSON. Den nya entiteten har bara `id`, `x`, `y` och ett tomt `padding`-fält. Beslutet återger också kontroller och underlag för den befintliga världen.

Detta är en separat profilering efter den avslutade Core 031-undersökningen, baserad på commit `6de1c8e`. Tidigare evidens och dess completion-index har inte skrivits om. Profileringen ändrar inga produktionskällor på grenen.

## Exakt storleksfördelning

| Del | Byte | Andel av hela dokumentet | Innehåll |
|---|---:|---:|---|
| `trace` | 3 227 329 | 79,00 % | 8 193 entitetskontroller, ett skapande och en global invariant |
| `facts.fields` | 408 491 | 10,00 % | Observerat `x` för de 8 192 befintliga entiteterna |
| `facts.universe` | 326 598 | 7,99 % | Hela föräldratillståndets entiteter, med fältvärden |
| `facts.queries` | 121 984 | 2,99 % | Alla 8 192 query-medlemmar och query-identiteter |
| Resterande JSON | 789 | 0,02 % | Identitetsfakta, request, skapad entitet, profiler, omslag och avgränsare |

De fyra första raderna avser exakt storlek på respektive JSON-värde, utan dess överordnade fältnamn/kolon. Sista raden är den exakta restposten så att tabellen summerar till dokumentets storlek. MB betyder här 1 000 000 byte; dokumentet är cirka 3,90 MiB.

Referensmodellen har entitetsregeln `E.x > 0` och en global övre gräns för antalet E. Varje `constraint_post`-post tar ungefär 394 byte. Den upprepar regelhashen, regelidentiteten, entitetsidentiteten, fasen, resultatet, lästa värden och fältobservationen. Regelhashen förekommer både som trace-hash och i `obligation`. Det blir över 3,2 MB för en mycket enkel regel.

Det finns två skilda kostnader:

- Core återanvänder kontrollerade mallar för gamla entiteter; predikatet behöver inte beräknas igen för varje gammal entitet.
- Core materialiserar ändå varje normativ trace-post och observerat fält, och tar med hela föräldrauniversumet. Denna evidens ska kunna kontrolleras och reproduceras självständigt.

Den optimerade räkningen ändrar därför inte det befintliga dokumentets linjära storlek. Query-medlemmarna är föräldramängden om 8 192 entiteter; den globala kontrollens resultat gäller sluttillståndet om 8 193. Den skapade entiteten redovisas separat i `lifecycle`.

Källor: [mallkopiering](../../../../crates/behavior-core/src/eval/prepared.rs), [utvärdering och universe-infogning](../../../../crates/behavior-core/src/eval.rs), [slutet record-format och dess validering](../../../../crates/behavior-core/src/record.rs), [persistenskontraktet](../../../../docs/persistence.md). [Exakt byteanalys](record-breakdown.json) innehåller även ett konkret trace-exempel.

## Mätning av ett enda evaluate/commit-par

Release-optimerad Rust, InMemoryBackend, CPU-affinitet 7, 8 GiB adressrymdsgräns, 120 sekunders processgräns. Varje repetition skapar en ny Store; installation, kompilering, genesis och skrivning av mätartefakter ingår inte i evaluate/commit. Tre repetitioner per punkt; samma process används för repetitionerna, så allokeraren kan vara varm. OS-cache är inte tömd och den fysiska värden är inte exklusiv. De första repetitionerna är långsammare och är kvar i rådata.

De ursprungliga åttastegsfallens modul och count-gräns behålls, men bara första skapandet exekveras. Den nya första beslutsakten vid N=8192 är byteidentisk med den frysta akten; detta är inte ett nytt försök att jämföra olika modulversioners prestanda.

| Befintliga entiteter | Beslutsbyte | Evaluate, median ms | Commit, median ms | Endast JSON-serialisering av färdigt beslut, median ms |
|---|---:|---:|---:|---:|
| 128 | 64 742 | 3,92 | 19,83 | 1,10 |
| 512 | 254 822 | 15,00 | 85,83 | 3,98 |
| 2 048 | 1 019 335 | 65,92 | 379,01 | 10,00 |
| 8 192 | 4 085 191 | 277,35 | 1 657,72 | 38,77 |

Evaluate och commit är separata medianer. En fristående serialisering är inte hela bearbetningskostnaden och ingår inte som ytterligare fas i samma evaluate/commit-latens. [Rådata](baseline.json), [metod och CPU](method.json).

## Vad Rust-koden gör med dokumentet

En separat `validation-work`-byggning har nästlade tidsprober. Följande avser **en faktisk repetition**, N=8192, repetition 1: evaluate 274,59 ms och commit 1 769,27 ms. Tiderna är väggklockstid, inte hårdvarusamplad CPU-tid. Proberna påverkar kostnaden och den instrumenterade commit-tiden är cirka 7 % högre än den oinstrumenterade medianen. Det är inte en uppmätt optimeringsvinst.

### Evaluate

- Materialisering av gamla entiteters trace-/fältmallar: **55,9 ms**.
- `with_current_profile`, egen tid: **50,4 ms**, i detta legacy-språkfall bland annat separat diagnostik och normalisering. Det är inte en ny JSON-parsning.
- Kopia av beslutsdokumentet för returvärdet: **33,9 ms**. Ytterligare kopior/frisläppning ligger i överordnade funktioner och är inte separat allokeringsprofilerade.
- Hashning av beslutets transition-identitet: **51,8 ms inklusive kanonisering och SHA**.
- Bara **tre predikat** beräknas; 8 192 gamla rader passerar mallvägen.

Dessa rader är separata instrumenterade delar; de beskriver inte alla 274,59 ms.

### Commit: disjunkta tider

| Bearbetning | Egen/uteslutande tid, ms |
|---|---:|
| Record-validering v0.8 och dess gemensamma v0.7-validering | 335,32 |
| Två strikta JSON-parsningar | 99,15 |
| Omvandling av Store-dokument till ägda JSON-träd inför hashning | 156,33 |
| Kanonisk JSON-serialisering och kontroll av kanoniska värden | 114,10 |
| Själva SHA-256-steget, sju anrop inklusive små dokument | 108,13 |
| Två uttryckligt instrumenterade bundle-kopior | 87,67 |
| Serialisering av beslutet inför reproduktion | 36,37 |
| Ny materialisering av entitetskontrollernas mallar vid reproduktion | 53,90 |
| Profil-/diagnostikbyggande vid reproduktion, egen tid | 52,12 |
| Extra serialisering **enbart för befintliga diagnostiska byte-räknare** | 122,26 |
| Övrig tid i instrumenterade funktioner | 503,82 |
| Summa inom commit-roten | 1 769,26 |

Detta är en väggklockpartition, inte en allokerings- eller kopieringsvolymmätning. Restposten omfattar återstående arbete i bland annat Store, reproduceraren, fakta, jämförelser, backend och materialisering/frisläppning. Ingen mer precis attribution av dess interna allokeringar görs här. Cirka 0,01 ms ligger utanför den instrumenterade roten.

Commitens överordnade `rederive_for` tar **884,0 ms inklusive underanrop**, ungefär hälften av commit. Dessa 884 ms ska inte adderas till tabellen. Call-kedjan visar:

1. Store serialiserar den mottagna beslutsakten för reproduktion.
2. `reproduce_record` avkodar den till ett JSON-träd.
3. `replay_profile` serialiserar trädet igen och `DecisionRecord::from_json` avkodar det en andra gång.
4. Record v0.8 valideras via en ägd typad representation. En kopia/projektion går därefter genom den gemensamma v0.7-valideringen, med ytterligare typad avkodning. Dessa steg gör mer än ren byte-parsning.
5. Den exakta utvärderingen reproduceras och evidensen jämförs. Även denna körning beräknar bara tre predikat, men bygger samma stora trace-/faktaunderlag.
6. Store serialiserar och hashar bundle samt historikhändelse. Det finns **två hashningar av `behavior.transition_record.v1`**, bland annat eftersom backend kontrollerar den mottagna atomiska händelsen. Mätningen visar upprepningen; den visar inte att någon kontroll får utelämnas.

Store-dokumentens fem namngivna hash-anrop bearbetar **13 851 594 JSON-byte** vid denna commit. Räknaren omfattar inte alla andra hashvägar, exempelvis beslutets separata transition-hash. Sju SHA-anrop totalt syns i proberna. Den äldre `record_parse_calls`-räknaren visar ett anrop, medan proberna visar två anrop till strikt avkodning: räknarens omfattning är alltså snävare än all faktisk parsning.

[Full profil och valideringsresultat](profile-summary.json), [alla 21 instrumenterade körningar](instrumented.json), [exakt instrumenteringspatch](instrumentation.patch), [källidentiteter](profile-source.json).

## Kontroller som skiljer orsakerna åt

Här ändras reglerna avsiktligt i experimentmodulen. De är orsaksundersökningar, inte föreslagna domänändringar eller semantiskt ekvivalenta optimeringar. Alla tre repetitioner av varje variant ger identiska beslutsbytes och den förväntade trace-strukturen.

| Variant, N=8192 | Beslutsbyte | Instrumenterad evaluate, median ms | Instrumenterad commit, median ms |
|---|---:|---:|---:|
| Ursprunglig modul | 4 085 191 | 280,99 | 1 769,27 |
| Utan global count-regel | 3 962 977 | 265,02 | 1 688,91 |
| Utan lokal `x > 0`-regel | 449 757 | 51,55 | 304,79 |
| Utan båda | 327 543 | 27,07 | 179,71 |

Det stora trace-blocket drivs alltså av den fullständigt redovisade entitetsregeln. Count-regeln tillför framför allt query-medlemslistan. Även utan reglerna ligger hela föräldrauniversumet kvar i det nuvarande record-kontraktet. [Förlustfritt packade beslutsakter och hashvärden](record-artifacts.json) gör varianterna granskningsbara.

## Slutsats och gränser

Ett skapande kräver inte matematiskt 4 MB ny information. **Det nuvarande evidensformatet kräver däremot denna fullständiga, upprepade representation för just detta fall.** Därför kvarstår storleksberoendet även när semantisk validering återanvänds korrekt.

Profileringen pekar på två skilda förbättringsbeslut:

1. Med oförändrade beslutsbytes: undersök färre ägda träd/kopior och upprepad avkodning samt operationell återanvändning av redan självständigt kontrollerade värden. Behåll samtliga kontrollgränser, felutfall och byte-identiteter. Ingen av dessa optimeringar har implementerats eller korrekthetsbevisats här.
2. För att själva dokumentet ska sluta växa med hela världen: ett separat, versionshanterat evidenskontrakt med fullständig replay-/fullständighetsargumentation. Att bara utelämna gamla entiteter eller ersätta allt med en StateId-hash är inte en verifierad lösning.

Proberna ändrar inga Core-beslutsbytes: alla tolv ordinarie instrumenterade fall är byteidentiska med sina oinstrumenterade motsvarigheter. De mäter inte allokeringsantal, fullständig kopierad bytevolym, profiler för andra backends eller produktions-SLA. Inga fulla produktionsgates behövde förnyas eftersom produktionskoden på grenen är orörd; evidens och variant-/span-kontroller har körts för denna separata undersökning.
