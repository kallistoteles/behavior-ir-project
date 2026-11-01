# Från genomförda undersökningar till arkitekturbeslut

Genomgång 2026-11-01 av samtliga 13 huvuddelar i
[undersökningskartan](../../research/investigation-map.md). Granskningen gäller
rapporter, kontrakt, avgränsningar och utvalda primärartefakter; den är inte en
omkörning av alla gamla experiment eller en oberoende kernelkontroll av alla
externa bevis. Tidigare förseglade mätningar lämnas oförändrade.

Källorna för Core 029–032 är [bevarade här](../../research/core-architecture-20261101/sources/README.md)
så att hänvisningarna går att läsa på GitHub. Manifestet anger exakta bytes,
ursprung och relation till det bevarade källträdets commit.

| Nr | Vad underlaget faktiskt visar | Konsekvens för nya Core |
| --- | --- | --- |
| 1. [029: inkrementell validering](../../research/core-architecture-20261101/sources/core/specs/029-incremental-global-validation/evaluation-report.md) | Avgränsad lokal/count-validering kan återanvändas vid exakt parent; kvarvarande fulla underlag kostar. | Bevara induktiv giltighet, men låt representation och oberoende kontroll bära samma återanvändning. |
| 2. [031: fem skalningsområden](../../research/core-architecture-20261101/sources/core/specs/031-scalable-execution-evidence/investigation.md) | Data, historik, evidens och livstids-ID:n växer på olika sätt. Få nya predikat betyder inte liten transaktion. | Separera N/U/H/D/B och normera historik, livstidsmängd, underhåll och revision. |
| 3. [Ett enda skapande](../../research/core-architecture-20261101/sources/core/specs/031-scalable-execution-evidence/profiling/single-create-20261028/report.md) | Vid N=8192 gav ett fall cirka 4 MB beslut, till cirka 79 procent trace. | Full rapport får inte vara mellanrepresentation och obligatoriskt hashunderlag för varje ny händelse. |
| 4. [Alternativ](../../research/core-architecture-20261101/sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/architecture-options.md) och [autentiserade strukturer](../../research/core-architecture-20261101/sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/authenticated-structures.md) | Reuse, persistenta sekvenser, autentiserade index och bevisackumulering är etablerade byggdelar med skilda garantier. | Använd dem för sina exakta skyldigheter; importera inte externa theorem som Core-bevis. |
| 5. [Första principer](../../research/core-architecture-20261101/sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md) | Exakt F, J, säkerhet, behörighet och återskapbarhet måste skiljas åt. | Gör ett gemensamt semantiskt kontrakt och namnge tillits-/tillgänglighetsgränser. |
| 6. [Greenfield och komposition](../../research/core-architecture-20261101/sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md) | Bred interpreter, inkrementell checker och VM/RAM är alternativ; rätt sammansatt relation avgör. | Välj K som auktoritet; ackumulera hela denna relation inklusive init, identiteter och outputs. |
| 7. [032](../../research/core-architecture-20261101/sources/core/specs/032-transition-verification-study/investigation.md) | Underhållna vyer, separat checker, DAG och liten Nova är verkliga prototyper. Full J/återspel, saknad full brygga, okomprimerat bevis och dyr kallstart kvarstod. | Upprepa inte helkontroll som verifiering. Kräv exekverbar-/kretsmotsvarighet och färdig komprimering redan i första vertikala försöket. |
| 8. [Strikt avkodningsreuse](../../research/core-continuation-20261029/report.md) | Samma data avkodades flera gånger; kompatibel reuse gav begränsad vinst. | Typade kontrollerade värden går vidare inom operationen; ingen återavkodning som intern säkerhetsritual. |
| 9. [Typad materialisering](../../research/core-typed-record-20261031/report.md) | Återanvändning fungerar, men arrayformad trace behövde kompatibilitetsväg; första serialisering kunde bli sämre. | Formell ingress-/renderingmotsvarighet omfattar verkliga tillåtna former, inte bara gynnsam objektform. |
| 10. [Kvarvarande kostnader](../../research/core-residual-profile-20261031/report.md) | 156 prober visade verklig kontextberoende serialiseringskostnad och återstående hashing/konvertering. | Mät den verkliga slutpunkten och hela livscykeln; en snabb intern fas är ingen transaktionstid. |
| 11. [Bundle-ägarskap](../../research/core-bundle-ownership-20261031/report.md) | En stor kopia gick att ta bort; mätta vinster var måttliga/blandade. | Ägarskap och strukturell delning behövs, men kan inte ersätta ändrad arbetsmängd. |
| 12. [Samlad optimering/PMU](../../research/core-final-investigation-20261031/report.md) | 1215 processer byte-lika; evaluate+commit+första serialisering förbättrades 22,06–30,82 procent i de sex fallen. En mindre v2-försämring kvarstod. | Behåll som kompatibilitetsreferens. Dra inget millisekund- eller arkitekturslutsats från procentsiffran. |
| 13. [Omprövning](../../research/core-redesign-reassessment-20261101/scope.md) och [forskningsåterkoppling](../../research/core-redesign-reassessment-20261101/researched-alternatives.md) | Inkrementell kompilering och glesa vittnen var redan identifierade och uppskjutna, inte motbevisade av 032. | Pröva just denna arbetsförändring med sammanhängande init→steg→historik och absoluta tider. |

## Forskning som används och gränsen för dess bidrag

DBSP ger en formaliserad inkrementaliseringsalgebra med specifika grupp- och
primitivpremisser. ILC och cache-transfer ger korrekta förändringsprogram under
sina förändrings-/cachevillkor. De motiverar effektiv **produktion** av K-underlag
och bevisade underhållslagar; de ersätter inte Core-specifik ordning, partiell
aritmetik eller observation. [DBSP](https://www.vldb.org/pvldb/vol16/p1601-budiu.pdf),
[ILC](https://inc-lc.github.io/resources/pldi14-ilc-author-final.pdf),
[CTS, versionsbundet theorem](https://github.com/yurug/cts/blob/ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7/coqproof/Overview.v#L95).

Autentiserade queryindex och aggregat ger tekniker för komplett intervallsvar och
aggregering vid en accepterad rot. Core måste fortfarande bevisa att roten har
sin rätta betydelse efter varje uppdatering. Hashar ensamma räcker inte.
[Index](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf),
[aggregat](https://www.cs.bu.edu/~reyzin/papers/auth-db-agg.pdf).

Nova ger ackumulering/komprimering för den relation som faktiskt implementeras.
Arkitekturen behöver en annan, fullständig Core-relation än 032:s begränsade
experiment. Parametrar, returned state och expected endpoint måste checkas.
[Versionsbundet Nova](https://github.com/microsoft/Nova/tree/01b1e2d662a847ed7029770ecbaf6687398899dd).

CompCerts kontrollerade allokeringsresultat och CakeLPR visar varför en
kontrollerad produkt kan minska tilliten till en komplex producent. De levererar
inte denna Core-checker eller dess kretsbrygga.
[CompCert](https://compcert.org/doc/html/compcert.backend.Allocation.html),
[CakeLPR](https://cakeml.org/tacas21.pdf).

De exakta tidigare inspekterade revisionerna och källbegränsningarna finns i
[forskningsåterkopplingen](../../research/core-redesign-reassessment-20261101/researched-alternatives.md).
Det nya bidraget här är ett uttryckligt Core-arkitekturbeslut, gränssnitt,
identitets-/evidenskontrakt, korrekthetskedja och falsifierbara bygggrindar.
Det är ingen ny kryptografisk primitiv eller redan verifierad produkt.
