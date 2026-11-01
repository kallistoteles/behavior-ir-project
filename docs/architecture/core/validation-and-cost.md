# Core: kostnad, publicering och bygggrindar

Detta gör [arkitekturbeslutet](README.md) prövbart. Inga nya körtider har
uppmätts för den föreslagna implementationen.

## Kostnaden följer den utlovade slutpunkten

Använd `N` levande entiteter, `U` använda identiteter under livstiden, `H`
publicerade händelser, `D` faktiskt påverkade semantiska skyldigheter, `A`
öppnade autentiserade noder, `W` nya lagringsbyte, `B` begärda exportbyte,
`K` bevismaskinens mikrostep och `R` krets-/release-segment. En skriven rad
innebär inte att D är litet. Kretsstorlek och maximal nod-/nyckellängd anges separat.

För ett framgångsrikt synkront anrop mäts hela intervallet:

```text
T_certified_commit = autentiserad läsning + beräkning + vittnesproduktion
                   + K-kontroll + ackumulering + komprimering
                   + oberoende slutverifiering + beständig atomisk publicering
                   + verkliga omtag vid konflikt
```

Delar kan överlappa eller dela arbete; totalen är väggtid för det verkliga
anropet. Den får inte konstrueras genom att addera medianer från separata körningar.
Minnesadapter och beständig adapter redovisas var för sig. Den senares fsync/
transaktionsbarriär, outbox, checkpoints och lagringsbyte får inte hamna utanför.

| Fall | Varför arbete behövs | Föreslagen förändring och kvarvarande kostnad |
| --- | --- | --- |
| Första installation | Språk, komplett modul, kontrollprogram och rätt parametrar måste antas. | Återanvänd versionsbundna kontrollerade artefakter; mät skapande, laddning, validering och minne. |
| Tom start | Tom Ω/J och ankare ska faktiskt certifieras. | Direkt startregel; ändå kostnad för nycklar, bevis, komprimering och lagring. |
| Första import | Godtyckliga tidigare okontrollerade data och livstidsfakta måste etableras. | En full kontrollerad konstruktion, sedan bevarad J; minst läsning av nödvändiga indata. |
| Kall certifierad återstart | Exakt ämne, användbara data och proverfortsättning måste återställas. | Verifierat certifikat, autentiserad lazy hämtning och kontrollerad checkpoint; första nyttiga operationens hämtningar räknas. |
| Lokal övergång | Ändringens exakta konsekvenser måste visas. | Arbeta över D/A och fasta underhållslagar; inte över alla gamla observationsrader. Krypto och lagring kvarstår. |
| Global ändring | En ny capture, regel eller referensändring kan påverka många. | Bevisad sammanfattning där sådan finns; annars komplett omberäkning i K. Kostnaden redovisas. |
| Ny historikverifierare | Hela prefixets semantiska giltighet ska etableras. | Komprimerat bevis för init och samma K; ingen full återspelningsbrygga. Kalla verifierarnycklar och transfer ingår. |
| Full export/datagranskning | Alla efterfrågade byte och felpunkter ska kunna granskas. | Återskapa från bevarat underlag och delning; minst Ω(B) skriv-/läsarbete under ett byteåtkomstkontrakt. |

Första import och full export kan inte ha en universell millisekundgräns
oberoende av godtyckligt stora in-/utdata. Att öppna en redan certifierad rot
har ett annat informationsläge än första import. Dessa kontrakt ska redovisas
öppet tillsammans; vi får inte byta namn på importen och gömma den i installationen.

## Absoluta mål för första avgörande försöket

Följande är **föreslagna byggmål**, inte användarbekräftade produkt-SLA:er eller
uppmätta resultat. De uttrycker ambitionen i millisekunder och ger en tidig stoppregel.
Frys maskin, versioner, säkerhetsnivå, lagringskontrakt och mätprotokoll före körning.

| Slutpunkt | Första mål på deklarerad referensmaskin |
| --- | --- |
| Lokal certifierad, beständig övergång | p50 ≤ 50 ms och p95 ≤ 100 ms, inklusive färdigt komprimerat bevis och slutkontroll. |
| Ny oberoende konsument, verifiering av ett certifierat prefix inom samma kretsrelease | p95 ≤ 100 ms från tillgängligt certifikat och installerat verifierarpaket till exakt kontrollerat ämne; kalla kontroller av paket/nycklar ingår. Ingen dold resident verifierarprocess. |
| Kall återstart plus första lokala certifierade övergång | p95 ≤ 250 ms, inklusive nödvändiga data, nycklar och tillgänglig provercheckpoint. Förlorad checkpoint mäts separat och får inte förväxlas med detta fall. |
| Tom genesis första användning | p95 ≤ 250 ms inklusive verklig runtime-installation/parameterförberedelse. Missat mål kräver ett öppet installations-/backendbeslut, inte påstående om uppfyllt startmål. |
| Rå import/full revision | Absolut tid, byte/s, N/U/H och minne för varje storlek; ingen universell konstant tidsgräns. Redovisa även när arbetet faktiskt utförs första gången. |

Referensfallen använder N = 128, 2 048 och 8 192, H = 1, 128 och 8 192 samt
oberoende variation av U med liten levande population. De lokala fallen omfattar
en faktisk lokal/count-skyldighet och bundet litet kommando-/resultat, inte ett
tomt steg som bara uppdaterar en räknare. Hög fanout, stora outputs och ändrade
globala captures är obligatoriska separata kostnadsfall. Kör både lågt tryck
och ett uthålligt belastningsfall med explicit ankomsttakt, köstorlek och genomströmning.

Innan insamling fryses den exakta modulen: en entitet med Int64-fält, en lokal
regel, en count-gräns, en referensrelation och en deklarerad kommandoemission.
Typade ID:n är högst 64 byte, kontext högst 1 KiB och kommandooutput högst 1 KiB;
en lokal operation skriver en entitet med högst 1 KiB payload. För de lokala
latensmålen hålls D ≤ 16; total ordnad summa och hög fanout mäts dessutom som
egna fall. U varierar över N, 16N och 128N. Exakt källfil/hash, indexkonfiguration,
requestsekvens och kallt cache-/processläge ingår i protokollet. Dessa gränser
avgränsar mätpåståendet, inte Core-språkets semantik.

Varje deklarerat scenario har minst 100 kompletta observerade prov för p95,
fler om spridningen kräver det, med råa tider och osäkerhetsintervall. Kalla
prov startar en ny process under dokumenterat OS-cacheläge; residenta prov
har separat uppvärmning. Ingen bortfiltrering av långsamma lyckade prov.
Byggtid för releasens formella artefakter redovisas separat från runtime-start;
all parameterhärledning eller kompilering som faktiskt görs vid deployment/anrop
räknas däremot i dess tid och livscykel.

För varje körning redovisas även total livscykel:
`install + init/import + cold open + Q×operation + fresh verification + audit + recovery`.
Visa råa sammanhängande prov, fördelningar, fel/timeout, toppminne, byteskrivning,
ackumulator-/checkpointstorlek och eventuella kvarvarande köer. Ingen slutlig
produktlatens fastställs förrän denna redovisning finns för alla tre huvudstegen.

## Bevisbackend: konkret första prövning, inget ärvt hastighetslöfte

Första jämförbara backend är den redan versionsbundna Nova-familjen med
Pallas/Vesta, Pedersen/IPA och Spartan-komprimering. Den är vald för att kunna
prövas mot befintligt material utan att samtidigt införa en ny SRS-livscykel.
Det är en experimentell implementationsriktning; den normerande arkitekturen
är den kompletta K-relationen och det synkrona certifierade gränssnittet.
Valt system, parametrar, säkerhetsantaganden, hashprofil, krets och komprimerare
måste frysas tillsammans i den första verifierarreleasen.

Den lokalt granskade [Nova-livscykeln](../../research/core-architecture-20261101/sources/core/specs/032-transition-verification-study/evidence/proof-lifecycle.md)
och [mätningen](../../research/core-architecture-20261101/sources/core/specs/032-transition-verification-study/evidence/cost-model.md)
visar ingen färdig sådan väg: 032 hade liten begränsad relation, ofullständig
Core-brygga och ingen komprimering. Dess separata parameteråteranvändning
eliminerade inte kall laddning/validering. Dessa resultat varken bevisar
millisekunder eller sätter en universell nedre gräns för en annan implementation.

Verifierarpaketet måste vara separat från stora proverparametrar. Konsumenten
installerar en betrodd exakt release eller härleder/checkar ett exakt recept;
den accepterar inte en nyckel bara för att producenten skickar den.
Cache är bunden till oförändrad krets/release. Första generering, key validation,
komprimeringssetup, kalla läsningar, proof transfer och faktisk slutverifiering
är egna mätpunkter. Om SHA-256-sökvägar eller synkron komprimering dominerar ska
relation, datastruktur eller backend omarbetas under samma semantiska kontrakt.
Ett native-svar före färdigt certifikat får inte rapporteras som slutresultatet.

Ett fast K-maskinsteg behandlar en begränsad del av ett godtyckligt långt
semantiskt steg. Programmet och data är autentiserat minne. Kretsstorleken ska
inte växa med N eller H; antalet mikrostep kan göra det. Slutpunkten måste vara
`Done`, med rätt logisk händelseräknare, inte bara en giltig inre fold.

## Publicering, konflikt och förlorat svar

1. Läs auktoritativ head och full aktivering. Kontrollera om `request_id` redan
   har ett exakt bundet resultat. ID:t är en uttrycklig idempotensnyckel bunden
   till originalrequest, parent och kontext; återanvändning med annat innehåll är fel.
2. Beräkna kandidaten privat från denna parent. Bygg immutabla data och kör K.
   Ingen gemensam vy eller outbox muteras spekulativt.
3. Producera, komprimera och oberoende verifiera kandidatens exakta certifikat.
   Utför detta utanför långvarig databaslåsning. En giltig kandidat är ännu inte publicerad.
4. Repository gör nödvändiga nya objekt och certifikatet beständiga. Nya
   referenser checkas; gamla objekt ärver det tidigare beständighets- och
   retentioninvariantet. Ingen full gammal grafgenomgång behövs per commit.
5. En kort atomisk transaktion jämför exakt parent och aktivering samt publicerar
   head, rötter, händelse, certifikat, request-resultat, outbox och retentionpins.
   Den jämför/sätter också unikt `(lineage, request_id)` med originaldigest
   atomiskt. Samma redan publicerade digest returnerar originalresultatet;
   annan digest ger ID-återbruksfel utan överskrivning eller ny commit.
   Upplösning av redan publicerat original sker före ett nytt parent-CAS-försök,
   så att en identisk retry kan få originalsvaret även efter att head gått vidare.
   Först efter adapterkontraktets beständighetsbarriär returneras `Committed`.
6. CAS-förloraren publicerar ingenting kanoniskt. Dess certifikat är en giltig
   annan gren, dess arbete räknas och dess oåtkomliga objekt kan samlas in.
   Inget tyst omtag mot ny parent med ändrad tid/kontext.
7. Om svaret försvinner returnerar upplösning med original-ID det ursprungliga
   eventet, kontexten, certifikatet och samma kommandohändelser. Ett timeout eller
   ett gammalt replika-svar om frånvaro tillåter inte blind ny publicering.

Negativ upplösning kräver auktoritativ färsk, serialiserad frånvaro och hantering
av eventuellt kvarvarande publiceringsintent. En Merkle-frånvaro vid gammal head
är bara frånvaro då. Fysiska externa effekter går genom beständig outbox och
hostens deduplicering/kvittenskontrakt. Ett replay får inte leverera dem igen.

Ett certifierat avslag/fel får en parentbunden försöksutsaga och en atomiskt
lagrad request-resultatpost innan svaret kvitteras; det flyttar inte
händelse-head eller kommandologg.
Samma atomiska ID-unikhet gäller dessa poster: avslag kan annars konkurrera
vid oförändrad head och undgå enbart parent-CAS. Den inledande lookupen är en
optimering, inte idempotensens korrekthetsgrund.
Om förväntad parent inte längre gäller returneras konflikt enligt kontraktet.
Behörighet vars färskhet krävs vid commit måste kontrolleras i samma
auktoritativa publiceringsdomän eller genom ett explicit externt protokoll.
Lokal CAS kan inte skapa atomicitet med en fristående behörighetstjänst.

## Återställning och retention

Återstart skiljer staged objekt, beständig publiceringsavsikt och kanonisk
manifest/head. Före publiceringspunkten gäller gammal head; efter den återställs
exakt det publicerade resultatet även om ingen kvittens skickades. Saknade eller
korrupta noder ger `Unavailable/Corrupt`, aldrig tom entitet/query.

Ett verifierat komprimerat certifikat bevisar inte att en godtyckligt
serialiserad proverackumulator kan fortsätta korrekt. Fortsättning kräver en
kontrollerad checkpoint med rätt ämne eller återuppbyggnad från tillräckligt
bevarat underlag. Alla nya slutcertifikat kontrolleras oberoende före publicering.
En okontrollerad proverblob får inte etablera native J eller ett kanoniskt head.

Att skriva en full stor ackumulator vid varje litet anrop kan återskapa samma
serialiseringsproblem. Pröva därför checkpoint efter ett bundet antal mikrostep,
med bevarad suffixhärledning och explicit begränsad återuppbyggnad. Mät verkliga
checkpointbyte, skrivkostnad och värsta återstart; anta inte att randomiserat
provertillstånd delar oförändrade sidor. Förlorad checkpoint kan blockera ny
certifierad publicering även när tidigare certifikat fortfarande är giltiga.

| Löfte | Vad som måste behållas |
| --- | --- |
| Verifiera exakt semantiskt prefix | Certifikat, förväntat ämne/ankare och verifierarrelease/nycklar. |
| Fortsätta | Aktuella värden/used IDs/vyer, rätt deklarationer, autentiserad åtkomst och kontrollerbar proverfortsättning. |
| Återskapa full revision | Genesis/adoption, requests/kontext, ordnade deltor och alla profiler/källor som receptets Expand behöver. |
| Leverera kommandon | Exakta förekomster med ordning och multiplicitet samt hostens beständiga leveransstatus. |
| Historisk datagranskning | Den historiska supportclosure som kontraktet lovar, även när den inte behövs för nästa vanliga operation. |

GC utgår från samtliga löften, pågående exports, aktuella och bevarade heads,
outbox och återställningscheckpoints. Den får inte bara markera levande entiteter.

Modul/policyändring inom samma K behandlas som explicita data med bevisad ny J.
Byte av själva K/kretsen kräver kontrollerad versionsbrygga eller segmentcertifikat.
Med R separata certifikat kostar färsk kontroll minst respektive segmentkontroll;
ingen O(1)-utfästelse över godtyckligt många releaser utan verklig ackumulerad brygga.

## Bygg i grindar som kan säga nej

**G0 — Frys betydelsen.** Inventera dagens syntax/API, välj ny evidensprofil,
specificera F/J/K, exakt kodning, observationsrecept och tillits-/lagringsmodell.
Gör en explicit gammal→ny betydelse- och migrationsmatris. Bevisa receptets
entydighet/expansion och att optimeringsval inte påverkar händelse-ID.

**G1 — Visa en verklig beviskedja.** Välj formell exekverbar implementation och
checkad översättning till native K och faktisk krets. Demonstrera en minimal men
äkta start→lokal/count-övergång→komprimerat certifikat→ny konsument utan full
Core-brygga. Inkludera exakt händelse/kommando/observation och intakt J.
Kör alla lifecycle-faser och absoluta tider. Saknad motsvarighet eller för lång
certifieringsväg stoppar påståendet att grunden löser målet.

**G2 — Pressa semantiken.** Lägg till 1000/1001-gräns, radering/ID-återbruk,
samtidiga referensändringar, tom→icke-tom query, ny capture, ordnad overflow,
lazy överhoppat fel, första-fel-ordning och identiska dubbla kommandon.
Mutera riktiga vittnen/index/rötter; visa att även ett säkert men felaktigt
posttillstånd och ett utelämnat tidigare fel avvisas. Bevisa relevanta lagar;
testfallen ensamma avslutar inte grinden.

**G3 — Gör hela språket komplett.** Fyll konstruktormatrisen i
[korrekthetskontraktet](correctness.md), med full producent inne i samma K.
Härled snabbare planer för dominerande verkliga mönster. Redovisa vilka
operationer som fortfarande skannar globalt och hur ofta. En framgång för
count-fragmentet får inte ärva etiketten full Core.

**G4 — Gör löftet beständigt.** Leverera minnesadapter och en faktisk beständig
referensadapter under samma kontrakt. Kör krascher före/efter varje
publiceringsbarriär, konflikt, förlorad kvittens, korrupt/missad data, förlorad
provercheckpoint och avbruten export. Bevisa eller ange exakt kvarvarande
lagringstrust. Visa återstart och första nyttiga fortsättning, inte bara rotacceptans.

**G5 — Avgör om målet är uppfyllt.** Frys protokoll och kör N/U/H-variation,
init/import, vanlig certifierad drift, ny konsument, kall start, revision och
återhämtning. Jämför samma slutpåstående med full referens och dagens bästa
formatbevarande kandidat. Om totalkedjan missar gränserna är den inte en
millisekundlösning; ändra maskin, sammanfattningar, representation eller backend.
Publicera negativa resultat med samma status som positiva.

**G6 — Inför med kontrollerad gräns.** Behåll gamla verifierare och oförändrade
gamla arkiv. Kör dubbel jämförelse före aktivering. En adoptionskontroll av gamla
prefix är explicit kostnad och bevisartefakt; endast ett betrott ankare innebär
ett uttryckligen svagare historikpåstående. Produktion aktiveras först efter
hela språkets, lagringens och prestandans grindar.

Byggordningen undviker att först lägga månader på en full förändringskompilator
och sedan upptäcka att den nödvändiga slutcertifieringen är för långsam. Den
prioriterar det som faktiskt kan falsifiera arkitekturvalet.
