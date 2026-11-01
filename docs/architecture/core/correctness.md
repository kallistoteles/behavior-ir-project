# Core: korrekthetskontrakt för den nya arkitekturen

Detta preciserar [arkitekturbeslutet](README.md). Påståendena nedan är
bevisförpliktelser för den framtida implementationen, inte färdiga Core-bevis.

## En enda semantisk relation

Låt `F_M(Ω, request, context)` vara exakt Core-evaluering under hela den antagna
modulen M och dess semantiska profil. Svaret innehåller valt utfall/fel, samtidig
effekt, nästa tillstånd, ordnade kommandon och fullständiga observationer. Full
modulidentitet omfattar även metadata som påverkar observationer; en identifierare
som avsiktligt utelämnar sådan metadata räcker inte som hela ämnet.

`J_M(Ω,V)` säger att alla använda vyer och sammanfattningar är exakta funktioner
av Ω, den aktuella modulen och den kontext deras definition tillåter. En vy som
beror på fångad kontext får inte återanvändas för en ny kontext utan rätt
underhåll eller ombyggnad.

Den centrala satsen är:

```text
ExpectedOrigin(Z₀) ∧ InitAccept(Z₀, witness₀)
  ⇒ Admitted(M) ∧ InitialValid_M(Ω₀)
   ∧ Represent(Z₀, Ω₀, V₀) ∧ J_M(Ω₀,V₀)

Represent(Z, Ω,V) ∧ J_M(Ω,V) ∧ KAccept(Z, request, context, result, Z', witness)
  ⇒ Denote(result, retained_support) = F_M(Ω, request, context)
   ∧ Represent(Z', Ω',V') ∧ J_M'(Ω',V')
   ∧ ExactHistoryAndOutputs(Z, request, context, result, Z')
```

M' skiljer sig från M bara vid en uttryckligt kontrollerad aktivering/migration.
`result` är den kompakta representationen. `Denote` tolkar dess explicita utfall,
effekter och kommandon samt expanderar observationsreceptet till det logiska
resultatet. Likheten kräver samma fullständiga betydelse, inte att programmet
materialiserar hela observationen innan det kan kontrollera steget.
Vid avslag/fel är Ω' = Ω och den publicerade händelsehistoriken oförändrad.
Ett försök har ett separat ämne som binder parent, input och resultat.

`ExpectedOrigin` är konsumentens explicit betrodda ankare/auktoritetsval, inte
producentens egen etikett. `InitialValid` innebär godkänd start enligt exakt
initieringssemantik: schema, referenser, identitetslivslängd och de initiala
regler som kontraktet kräver. Felaktig import ska ge föreskrivet avslag. Exakta
vyer över en ogiltig start räcker inte: ett korrekt cachat `x>0 = false` gör
inte `x=-1` till en giltig genesis. En betrodd ny genesis och en verifierad
adoption av äldre historik är olika ursprungsutsagor.

Det publika bevisämnet Z binder minst:

```text
ankare/genesis/adoption och lineage
full modul, schema, semantik, evidensprofil och komplett aktivering/policy
checkerprogram, kretsrelease och parameterrecept
innehållsrot, permanent used-ID-rot och hjälprots-ämne med J
händelseposition, exakt händelse-head och loggrot/längd
ordnad kommandologg och retentionkontrakt
maskinfas, mikrostegräknare och färdigställandestatus
```

Den semantiska händelseidentiteten beror på semantiska data. Hjälprots-ämnet kan
variera mellan korrekta accelerationer och ingår därför i certifikatets ämne,
inte i den kanoniska affärshändelsens identitet. J måste ändå knyta dessa rötter
till samma innehåll. Fulla digester kodas injektivt med range-checkade bitar/limbs;
att reducera en 256-bitars digest modulo ett mindre fält är inte samma bindning.

## Hur K kan kontrollera lite utan att anta resten

K innehåller följande fasta regelfamiljer:

| Regel | Premiss som kontrolleras | Vad den får etablera |
| --- | --- | --- |
| `Eval` | Exakt syntax, typ, miljö, fas och delhärledningar. | Rätt värde/fel, lazy-val och ordnade observationer. |
| `Read/Update` | Autentiserad medlem/icke-medlem, typad kodning och exakt gammal rot. | Exakt läsning eller beständig ändring till ny rot. |
| `Maintain` | Tidigare J, full faktisk delta och en fast bevisad vylag. | J för den uppdaterade vyn. |
| `Reuse` | Tidigare etablerad härledning, rätt ämne/kontext och bevisat oförändrade kompletta beroenden. | Samma stabila semantiska resultat; aktuella ramfält injiceras enligt bevisad regel. |
| `Cover/Frame` | Komplett regelinventering, ämnespartition och konservativ påverkansanalys. | Att ingen tillämplig regel eller tidigare fel har hoppats över. |
| `Finalize` | Alla faser stängda, exakt samtidig effekt, output och kanoniskt händelsehuvud. | Ett komplett semantiskt steg, inte ett halvt maskinspår. |

Inventeringen härleds från **hela antagna syntaxen**. Om en plan föreslår den ska
K kontrollera dess täckningscertifikat; producentens egen lista är ingen premiss.
En snabb sammanfattning får bara användas för sitt bevisade uttrycksområde.
För övriga uttryck finns full evalueringshärledning i samma relation.

För en lokal skapelse med count-gräns behövs exempelvis färsk identitet,
distinkt ny entitet, exakt count-förändring, ny lokal regelkontroll och inramning
av opåverkade regler. K behöver inte jämföra varje gammal entitet med J igen.
Kontrollen av skapelse 1000 och avslaget för 1001 följer samma lag.

### Fullständighet omfattar negativa fakta

- En querymedlemslista kräver rätt urval **och** täckning av alla möjliga
  kandidater. Ordning och gränsbevis hör till rätt indexrot. Ett tomt resultat
  kräver en kontrollerad lucka eller komplett utvärdering.
- En insättning kan ändra en query som saknade medlemmar. Beroenden omfattar
  sådana frånvarofakta, typuniversum och fångade parametrar.
- Referensindexet är likhet med alla inkommande typade kanter. Borttagning
  kontrollerar det kompletta resulterande intervallet efter samtidiga effekter.
- Ett autentiserat count-värde bevisar inte att antalet är rätt. Det behövs
  etablerad J och komplett underhåll av alla relevanta insättningar/raderingar.
- Den ordnade regelpartitionen sammanfattar första relevanta fel och resultat.
  Ett vittne får inte utelämna en tidigare misslyckad regel för att visa en senare.
- Ändrade globala parametrar eller många inkommande referenser kan ge global
  påverkan. Okänd påverkan leder till full kontroll, aldrig till antagen frånvaro.

## Ett konkret smartare sätt: ordnad, kontrollerad summa

DBSP:s gruppalgebra får inte direkt ersätta en ordnad Int64-fold: mellanliggande
overflow är observerbar. Det finns däremot en exakt sammanfattning för en
**ren, total sekvens av redan framtagna Int64-värden**.

För en sekvens x lagras `(T, lo, hi)`: total matematisk summa och minsta/största
prefixsumma, inklusive det tomma prefixet. Beräkningen sker i exakta heltal.
Sammanfogning av ordnade delsekvenser är:

```text
(t,a,b) ⋄ (u,c,d) = (t+u, min(a,t+c), max(b,t+d))
identity = (0,0,0)
```

Detta är associativt eftersom det exakt beskriver prefixen i konkatenering.
Det är inte kommutativt. Med giltig startsumma z lyckas den kontrollerade folden
precis när `Int64.min ≤ z+lo` och `z+hi ≤ Int64.max`; resultatet är z+T.
Annars hittar man första overflow genom att gå vänster först och hoppa över
sammanfattat säkra delträd med uppdaterad startsumma.

Sekvensen `[Int64.max,1,-1]` måste fortfarande ge overflow medan
`[Int64.max,-1,1]` kan lyckas. En nyckeländring uppdaterar bara relevanta
sekvensvägar om urval, projektion och deras beroenden också är korrekt underhållna.
Sammanfattningens heltal behöver O(64 + log n) bitar för n Int64-element;
implementationen får inte själv overflowa vid underhållet.

Lagen ovan är matematiskt härledd här och i [kompilatoralternativet](../../research/core-architecture-20261101/candidates/delta-compiler.md),
men inte maskinbevisad i detta arbete. Den täcker inte en partiell projektion,
förändrad querymaterialisering, annan evalueringsordning, decimalrescale,
derived-memo eller full trace. Dessa kräver egna lagar för exakt fas/observation,
eller den fullständiga vägen. Detta visar hur man ersätter arbete med en
starkare datasammanfattning utan att ändra felets betydelse.

## Observationer och identiteter

Den acykliska semantiska identiteten definieras före certifikatets ämne:

```text
SemanticParent = (lineage, semantic_anchor, semantic_position, prior_EventId,
                  content_root, used_ID_root, active_semantic_subject)
CommandIntents = canonical ordered [(ordinal, declaration, bindings, payload)]
ObservationRecipe = (evaluation_observation_profile, full_module,
                     SemanticParent, request, captured_context)
EventId = HashTyped(profile, SemanticParent, request, captured_context,
                    exact_outcome, canonical_effects,
                    CommandIntents, ObservationRecipe)
CommandOccurrenceId = (EventId, ordinal)
```

`SemanticParent` innehåller inga certifikat-/hjälprötter, optimeringsplaner,
provercheckpoints eller mikrostegräknare från Z. `CommandIntents` innehåller
inte de förekomst-ID:n som härleds efter EventId. Den globala kommandologgens
nya rot skapas därefter och binds i slutcertifikatets Z'. Lika payloads med
olika ordinaler är fortsatt olika förekomster. Därmed finns ingen cirkel mellan
händelsehash och kommando-ID, och ingen transitiv cacheidentitet i parent.

Den nya profilens kanoniska observationsrecept är en typad, entydigt kodad
referens till evalueringsprofil, full modul, exakt parent, request och fångad
kontext. Händelsen binder också det kontrollerade utfallet, effekterna och exakt
ordnad kommandooutput. Determinismen gör hela observationen entydigt bestämd.

Den viktiga satsen är både:

```text
Expand(recipe, retained_authoritative_support) = Obs(F_M(Ω, request, context))
EventId(same_semantic_inputs_and_result, producer_a)
  = EventId(same_semantic_inputs_and_result, producer_b)
```

Expand kan köra om berörda beräkningar och kan behöva stora historiska data.
Det är exportens redovisade arbete. Optimeringsspecifika observationscacheträd
är hjälpdata; de får checkas och användas men ändrar inte det normativa receptet.
Aktuell parent, tid/kontext och bindings får inte läcka in från en gammal cache.

Den faktiska kodaren och renderaren omfattas av motsvarighetskravet. Typ,
domänseparation, längd, ordning och profilversion är normativt definierade.
Första hashkandidat är SHA-256 över typade noder/recept, inte över utvecklade
JSON-dokument. Kostnaden för dess kretsimplementation ska mätas. Byte till en
annan hash kräver uttryckligt versions-, säkerhets- och kodningsbeslut.
En ny root kan inte samtidigt kallas den gamla JSON-hashen eller MuHash-identiteten
utan en verklig, kostnadsredovisad brygga.

## Från matematisk relation till verkliga program

| Förpliktelse | Krävt artefakt och gräns |
| --- | --- |
| Ingress och antagning | Strikt avkodning, typning, fullständig syntaxinventering och metadata med bevisad relation till det versionsbundna kontraktet. |
| Start | Korrekt genesis/import/adoption etablerar hela Ω och J, även använda raderade ID:n och historik där sådan påstås. |
| K | Sundhet för exakt F, ärlig härledningsfullständighet för alla antagna konstruktioner samt varje reuse-, täcknings- och vylag. |
| Datastrukturer | Map-/sekvensbetydelse, kanonisk kodning, sökvägsuppdatering och fullständiga ordnade svar; kryptografisk bindning under namngivna antaganden. |
| Exekverbar verifierare | Det verkliga körda programmets parser, aritmetik, tillstånd och resultat förfinar K. Modellbevis plus separat handskriven Rust räcker inte. |
| Bevismaskin | Maskinsteg förfinar samma K inklusive minne, kod, fas, kodning och slutförande. |
| Faktisk krets | De emitterade constraint-matriserna och publika inputs motsvarar maskinstegen, inklusive bit-/range-villkor, digestbredd och initierat minne. |
| Ackumulering | Valt systems sundhet för exakt relation och init/slutämne; komprimering och verklig verifierarimplementation ingår. |
| Historik | Induktion från start genom färdigställda K-steg ger exakt Core-prefix och J vid slutpunkten. |
| Observation/identitet | Faktisk Expand/kodare förfinar specifikationen; semantisk identitet är producentoberoende. |
| Lagring/återställning | Atomisk exakt-parent-publicering och verifierad fortsättning förfinar det logiska tillståndet under angiven krasch-/diskmodell. |
| Aktivering/migration | Korrekt övergång mellan hela gamla och nya ämnen; inga ogrundade ärvda vyer eller säkerhetsbevis. |

Implementationsriktningen är en liten exekverbar formell K och en
genererad eller certifikatkontrollerad maskin-/kretsöversättning. Den första
bygggrinden ska välja och demonstrera den konkreta kedjan. Lean-modell till
separat Rust och separat krets lämnar en för stor lucka för det avsedda påståendet.
CakeML är ett granskat prejudikat för verifierad kompilering, inte ett redan
valt verktyg eller ett bevis för denna Core. Val av proof assistant/kompilator
får inte maskera portnings-, runtime- eller FFI-antaganden.

Givet dessa artefakter, betrott förväntat ankare, commitment-bindning och valt
bevissystems sundhet ska en oberoende accepterad slutpunkt innebära existens av
just den exakta Core-historien. Proverns valda nyckel eller påstående om sin egen
historik är aldrig ett oberoende tillitsankare.

## Hela språkets täckning

Releasegrinden inventerar faktiska syntaxkonstruktorer och publika operationer,
inte bara benchmarkmodulen. Minimikategorier är antagning/typer, nominella och
exakta/decimala värden, avrundning/rescale, Option/enum, uttryck och ordnade fel,
lazy/derived/memo, queries/folds, globala och lokala regler, simultana effekter,
alias/identitetslivslängd/referenser, kommandon, reads/invocations och migrationer.
Till varje kategori kopplas semantik, K-regler, full producent, möjlig snabb
producent, observationslag och maskin-/kretsmotsvarighet.

Ett ofyllt fält betyder att nya Core ännu inte täcker hela produkten. Det är
tillåtet att begränsa ett experiment; det är inte tillåtet att kalla experimentet
en färdig ersättare för Core. Differentiella tester och fientliga exempel är
nödvändiga, men ersätter inte dessa universella förpliktelser.

## Vad ett certifikat inte etablerar

Ett giltigt prefix bevisar inte att det är det senaste eller kanoniskt valda.
Förväntad head kommer från en betrodd linjäriserbar kontrollkälla eller ett
specificerat konsensuskontrakt. Komplett policyval, extern sanning och aktuell
behörighet kräver uttryckliga tillitsregler. Historisk giltighet uppgraderar inte
en gammal behörighet till dagens tillstånd och är inte ett bevis för alla framtida
övergångars Safety Model.

Ett prefixbevis visar inte heller att varje historiskt dataobjekt fortfarande
finns, att en export går att läsa eller att ett fysiskt kommando levererats en
gång. Dessa är separata retention-, revisions- och hostkontrakt. De är inte
utelämnade kostnader i ett löfte om full datagranskning.
