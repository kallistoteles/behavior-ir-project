# Undersökningar i Core-arbetet

Sammanställning 2026-11-01. Detta är 13 huvuddelar i den aktuella Core-utredningen,
inklusive förarbetet i Core 029. Flera innehåller egna delstudier. Listan skiljer
uppmätta experiment från arkitekturförslag och litteraturstudier.

Genomgången är nu omsatt i [ett rekommenderat arkitekturbeslut för nästa Core](../architecture/core/README.md),
med tre jämförda alternativ, sammanhängande korrekthetskrav och absoluta
bygggrindar. Det är en ny syntes av underlaget nedan, inte en uppmätt eller
färdigbevisad implementation.

| Nr | Undersökning | Fråga och viktigaste resultat | Typ |
| --- | --- | --- | --- |
| 1 | **Core 029: inkrementell validering** | Kan redan etablerad tillståndsgiltighet återanvändas? Ja, för avgränsade lokala regler och count-gränser. Fullständiga beslutsunderlag och historikkostnader kvarstår. | Implementerad avgränsad väg, korrekthetsargument och mätningar. |
| 2 | **Core 031: skalbar exekvering och evidens** | Vad växer med datamängd, historik, ändringar, regler och evidens? Kartlade fem problemområden och visade att kostnaden inte främst är upprepade predikatberäkningar. | Mätkampanj, kostnadsmodell och villkorade algoritmargument. |
| 3 | **Profilering av ett enda skapande** | Varför ger en liten ny post ett beslut på cirka 4 MB? Vid 8 192 befintliga entiteter var cirka 79 procent trace; kopiering, validering, serialisering och hashning tog stor tid. | Storleksanalys och tidsprofilering. |
| 4 | **Arkitekturalternativ och autentiserade strukturer** | Hur kan återanvändning, beroenden och bevismaterial representeras annorlunda? Granskade bland annat Authentikit, inkrementella kompilatorer, persistenta sekvenser, autentiserade index, checkpoints och Nova. | Primärkällestudie och arkitekturförslag. |
| 5 | **Undersökning från första principer** | Vad måste Core faktiskt etablera, oberoende av dagens implementation? Skilde exakt exekvering, säkerhet, ursprung/behörighet, historisk identitet och återskapbarhet. Härledde underhållna vyer, vittneskontroll och inkrementell kompilering som olika vägar. | Kravanalys och matematiska designförpliktelser. |
| 6 | **Greenfield-omdesign, IVC och bevissammansättning** | Hur kan en ny beräknings- och evidensmodell kopplas till ackumulerade bevis? Jämförde kompakt native-evidens, bred interpreter, inkrementell checker och VM/RAM-spår. Ingen komplett Core-arkitektur bevisades eller mättes här. | Arkitektur- och forskningsstudie. |
| 7 | **Core 032: verifierade inkrementella övergångar** | Prövade underhållna vyer (A), oberoende vittneskontroll (B), delad DAG och verklig begränsad Nova-ackumulering. Innehåller även Lean-resultat, uppstart/återställning, parameterlivscykel, checkpoints och oberoende konsument. Prototyperna behöll dyr full kontroll/återspelning; ingen visade den kompletta millisekundlösningen. | Körbara prototyper, avgränsade formella resultat, negativa kontroller och mätningar. |
| 8 | **Återanvändning av strikt JSON-avkodning** | Kan samma data slippa avkodas upprepade gånger inom ett anrop? Mätt förbättring med bevarade resultat och fel. | Kompatibilitetsoptimering och tester. |
| 9 | **Typad record-materialisering** | Kan redan avkodade fält flyttas vidare i stället för att byggas om? Gav förbättringar och identifierade en nödvändig kompatibilitetsväg för arrayformade traces. | Trearmsförsök, tester och mätningar. |
| 10 | **Kvarvarande kostnader och första serialiseringen** | Vad återstår efter typad återanvändning, och varför varierar första textomvandlingen? Bekräftade en verklig kontextberoende försämring och kartlade återstående arbete. | Profilering och 156 mätprober. |
| 11 | **Ägarskap för arkiverad bundle** | Kan en färdig ägd bundle flyttas in i händelsen? En tillfällig stor kopia kunde tas bort; tidsvinsterna var måttliga och blandade. | Avgränsat experiment, tester och mätningar. |
| 12 | **Samlad formatbevarande optimering och allokerarundersökning** | Kombinerade tidigare steg med strömmande hashning och lånade dokumentvyer. 1 215 mätprocesser gav lika kompletta utdata. Kedjan evaluate+commit+serialisering blev 22–31 procent kortare i testfallen; allokerarprofiler förklarade stora förberedelsekostnader. Det mindre v2-fallet har kvar en serialiseringsförsämring. | Samlad mätkampanj, kapacitets-/touch-försök och PMU-profiler. |
| 13 | **Arkitektonisk omprövning och forskningsåterkoppling** | Återställde målet: en korrekt och snabb kedja genom start, övergångar och oberoende historikkontroll. Kopplar kostnader till DBSP, ILC/cache-transfer, autentiserade queries och ackumulerade bevis. Inga nya Core-latenser eller implementeringsbevis har visats. | Källbaserad omprövning och preciserad fortsatt frågeställning. |

## Core 031:s fem delområden

Den breda undersökningen i punkt 2 omfattar:

1. Bearbetning av dagens evidensformat.
2. Bredare inkrementella queries.
3. Kompakt, verifierbar evidens.
4. Historisk verifiering och upprepade prefixkontroller.
5. Begränsning av levande tillstånd, identitetslivslängder och retention.

## Rapporter och källor

Originalen för punkt 1–7 ligger i Core-källträdet. De bevarade källorna och deras
begränsningar sammanfattas i [genomgången av tidigare design och evidens](core-redesign-reassessment-20261101/prior-design-evidence.md).
Originalens huvudingångar är:

- `specs/029-incremental-global-validation/evaluation-report.md`
- `docs/incremental-validation.md`
- `specs/031-scalable-execution-evidence/investigation.md`
- `specs/031-scalable-execution-evidence/profiling/single-create-20261028/report.md`
- `specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/`
- `specs/031-scalable-execution-evidence/profiling/first-principles-20261028/`
- `specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/`
- `specs/032-transition-verification-study/investigation.md`

Rapporter för de senare delarna:

- 8: [Strikt avkodning](core-continuation-20261029/report.md).
- 9: [Typad materialisering](core-typed-record-20261031/report.md).
- 10: [Kvarvarande kostnader och serialisering](core-residual-profile-20261031/report.md).
- 11: [Bundle-ägarskap](core-bundle-ownership-20261031/report.md).
- 12: [Samlad optimering och allokerarprofilering](core-final-investigation-20261031/report.md).
- 13: [Korrigerad frågeställning](core-redesign-reassessment-20261101/scope.md) och
  [redan forskade alternativ och deras bevisgränser](core-redesign-reassessment-20261101/researched-alternatives.md).

DBSP, inkrementell kompilering, autentiserade strukturer och Nova är alltså redan
identifierade och granskade. Den öppna uppgiften är att pröva en Core-specifik
sammansättning som verkligen undviker full omberäkning/återspelning, bevisar
motsvarigheten och visar absoluta tider för hela den utlovade kedjan. En ny
allmän litteraturlista eller ytterligare procentförbättring av samma modell
räcker inte för att avsluta den uppgiften. Arkitekturbeslutet anger nu vilken
sammansättning som rekommenderas och exakt vad som måste bevisas och mätas för
att den ska räknas som en fungerande lösning.
