# Algoritmus
Az algoritmus lényege, hogy minden lépésben egy long-range élet mintavételezek, és ha ez közelebb van a célhoz, mint bármelyik közvetlen szomszéd, oda lépek, egyébként pedig a legközelebbi közvetlen szomszédhoz.

## Naív megközelítés
A feladatot az teszi nehézzé, hogy ha naív módon mintavételezzük a long-range élet, akkor maga a mintavételezés futásideje és memória igénye is $O(n^2)$ lesz. Ez jelentősen lassúvá teszi az algoritmust és ezzel egyidőben nem enged meg nagyon nagy $N$-eket, a memóriából gyorsan kifutunk.

## Én megközelítésem
Az alapötletet abból a megfigyelésemből indítottam, hogy a long-range él mintavételezése során minden $d$ távolságra lévő csúcsot egyforma valószínűséggel mintavételezzük. Ezt kihasználva meg tudjuk csinálni, hogy a csúcsok feletti eloszlásból vett minta helyett először egy távolságot mintavételezünk, majd az adott távolságra lévő csúcsok közül egyenletesen mintavételezünk.

Ehhez a naív implementáció szintén $O(n)$ futásidejű, hiszen egy $N$ elemű multinomimális eloszlásból kell mintavételeznünk, majd egyenletesen $N$-el arányos csúcsból.

### Távolság mintavételezése konstans időben.
Az Alias Sampling egy olyan mintavételező algoritmus, amely diszkrét eloszlásból tud mintavételezni $O(1)$ időben. Ehhez ugyan elő kell állítani egy segéd tömböt, viszont azt csak egyszer per 1000 futás, és utána az 1000 futásban konstans időben mintavételezhetünk. Ezt az algoritmust használtam a távolság mintavételezésére.

### Csúcs mintavételezése feltételes eloszlásból
Ha már ismerjük a távolságot, könnyen számítható, hogy adott $N$ érték mellett ebből a távolságban hány csúcs van:
$$K = 4*d, ha d <= 4*(N/2, 2*N/2 - d-1) különben$$
Illetve az is megoldható, hogy indexelhetőek legyenek a $d$ távolságra levő csúcsok (azaz konstans időben adott indexhez kiválaszthassunk csúcsot a K csúcsból).

### Rejection sampling
Mivel nem mindig középről mintavételezünk, ezért rejection samplinget alkalmazok egy $2N$ méretű rácsból az $N$ méretű rácsra. Ez méréseim alapján ~4.5 mintavételből megáll. Ha az algoritmust egy toroid gráfon implementáltam volna, ez elkerülhető lenne - azaz ~4.5 szörös gyorsulás lenne elérhető.

# Párhuzamosítás grafikus gyorsítón
A szimuláció python-ban való futtatása jelentősen lassabb, mintha ezt valami hardware közelibb módon tennénk. A szimuláció felgyorsításának érdekében azt CUDA-ban implementáltam, így grafikus gyorsítón futtatva nagyságrendekkel gyorsabban megkapjuk az eredményt.

Így képes voltam futtatni N=1_000_000 rácsméretre is a szimulációt ~4 perc alatt. A cikkben szereplő N=20_000 rácsméretre így <5 másodperc alatt fut a szimuláció.