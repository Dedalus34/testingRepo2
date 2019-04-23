import UIKit

// Generics in Swift 5:

// Creiamo una funzione con un compito molto semplice, inserendo due variabili, scambia i valori
// all'interno di esse:

func swapInts(_ a: Int, _ b: Int) {
    // Notiamo subito come il compilatore segnali diversi errori quando scambiamo i valori.
    // Questo è dovuto al fatto che quando inseriamo delle variabili o costanti come parametri di
    // una funzione, non stiamo passando direttamente la variabile, ma una copia del loro contenuto
    // che verrà posto all'interno di due costanti di nome 'a' e 'b' (Praticamente lo stesso discorso
    // che facciamo in C++ riguardo al pass by value).
    // Dunque, anche se quando richiamiamo la funzione inseriamo tra i paramatri delle variabili, non
    // stiamo passando la variabile di per se, ma solo una copia del suo contenuto.
    
    //let tempA = a // Tutto questo segnalava errori!
    //a = b
    //b = tempA
}


// Per ovviare a tale problema utilizziamo nella dichiarazione della funzione, tra i parametri,
// la keyword 'inout' (sarebbe come usare l'& in C++), ciò ci permette di passare l'indirizzo della
// variabile inserita come parametro, permettendo la reale modifica della stessa.

func swapInts2(_ a: inout Int, b: inout  Int) { // Stessa funzione ma utilizzando inout.
    
    let tempA = a
    a = b
    b = tempA
}

// testiamo la funzione:

var c: Int = 10
var d: Int = 16

swapInts2(&c, b: &d) // Da notare come richiamando la funzione ci siano poste le &.

// Come sappiamo questa operazione è detta 'Pass By Reference'.

// E se volessimo fare la stessa identica operazione ma utilizzando delle Stringhe?
// Sappiamo già che non possiamo richiamare swapInts2 in quanto accetta solo interi, dunque
// per poter effettuare la stessa operazione su stringhe dobbiamo ricreare un altra funzione
// avente parametri di tipo String.

func swapString(_ a: inout String, _ b: inout String) {
    let tempA = a
    a = b
    b = tempA
    // Da notare come iniziamo a rompere il DRY!
    // In queste funzioni cambiano solo gli argomenti, l'implementazione è identica.
}

// Una possibile prima soluzione potrebbe essere quella di utilizzare un tipo più alto, ad
// esempio 'Any', ma l'utilizzo di quest`ultimo non è molto sicuro.
// Ponendo come tipo 'Any' perdiamo la type safety, infatti potremmo inserire come parametri
// un Int ed una String e come sappiamo il nostro programma crasherebbe.
// Ci serve dunque una soluzione che ci dia più controllo ma che sia altrettando flessibile.

// MARK: Esempio di Generic function ( Sono i Template in C++, chaimati Type Parameters in Swift):

func swapValues<T>(_ a: inout T, _ b: inout T) {
    // T è un tipo generico, potremmo dargli qualsiasi nome vogliamo.
    // Quando richiameremo la funzione, in questo caso T assumerà il tipo del primo parametro
    // e lo applicherà anche al secondo, ciò ci permette di avere anche Type Safety ed evitare
    // d'inserire elementi con tipo diverso.
    
    let tempA = a
    a = b
    b = tempA
}

var p: String = "Arlong"
var h: String = "Park"
swapValues(&c, &d) // Funziona con gli Int.
swapValues(&p, &h) // Funziona con le String!

// Verifichiamo che gli elementi siano invertiti:
c
d
p
h


// Un altro esempio di Generic Function:
func duplicate<T>(item: T, numberOfTimes: Int) -> [T] {
    var arrayOfItems = [T]()
    for _ in 0..<numberOfTimes {
        arrayOfItems.append(item)
    }
    
    return arrayOfItems
}

// Esempio più complesso: Due parametri Generici

// La funzione prende due parametri di tipo T (quando definiamo dei valori generici, i nomi vanno
// assegnati seguendo le lettere del alfabeto in maiuscolo che vanno dalla T alla Z)
// di cui il secondo, operation, è una funzione che restituisce un elemento di tipo U (return type).
// Da notare che, oltre al utilizzo dei generics, abbiamo un buon esempio di come si utilizza una func
// come argomento! In questo caso la funzione dichiarata come argomento, dev'essere una funzione cui
// argomento è un elemento di tipo T e che restituisca un elemento di tipo U.
func transform<T, U>(arg: T, operation: (T) -> U) -> U {
    return operation(arg)
}

func stringToInt(_ a: String) -> Int { // Trasforma una String in Int.
    // Il guard viene utilizzato in quanto non tutte le stringhe possono essere trasformate in Int:
    guard let value = Int(a) else { fatalError() }
    return value
}

func intToString(_ a: Int) -> String { // Operazione opposta:
    
    // In questo caso non vi è il bisogno del Guard in quanto tutti gli Int possono essere
    // trasformati in String.

    return String(a)
}

transform(arg: "14", operation: stringToInt)

// Un altro esempio:
func map<T, U>(array: [T], transformation: (T) -> U)-> [U] {
    var arrayOfElements = [U]()
    for elements in array {
        arrayOfElements.append(transformation(elements))
    }
    return arrayOfElements
    
}

func square(of a: Int) -> Int { return a * a }
let arrayOfInts: [Int] = [ 10, 23, 61, 17, 15, 8]

// Da notare che non mettiamo parametri nella funzione passata come argomento in quanto il parametro
// lo specificheremo nel corpo della funzione.
map(array: arrayOfInts, transformation: square)

// I Generics in sunto ci permettono di scrivere codice che possiamo utilizzare con una maggiore
// varietà di tipi.
// Essendo che non sempre vogliamo che nelle nostre funzioni vengano utilizzati tutti i possibili tipi
// è possibile porre delle restrizioni:

// Protocol Based Constraints

// La nostra funzione ha due generic types che useremo come key-value pair per un Dictionary.
// Possiamo utilizzare i protocols per porre limitazioni ai valori generici, in questo caso ad esempio,
// Value deve per forza soddisfare il protocol Equatable, che come sappiamo stabilisce le regole ed i
// limiti in cui possiamo utilizzare l'operatore ==.
// Questa limitazione viene posta in quanto nella funzione inseriamo come parametro un valore e
// la funzione cercherà all'interno del dictionary se tale elemento esiste.
// Se esiste, restituirà la Key di quel valore:

func findKey<Key, Value: Equatable>(for value: Value, in dictionary: Dictionary<Key, Value>) -> Key? {
    for (iterKey, iterValue) in dictionary {
        if iterValue == value { // Se troviamo il valore restituiamo la key.
            return iterKey
        }
    }
    
    return nil
}

// Creiamo un array contenente String, il tipo soddisfa ed aderisce già al protocollo Equatable.
let airportCodes = ["CDG": "Charles de Gaulle", "HKG": "Hong Kong International Airport"]

// Infatti otteniamo il risultato senza problemi.
findKey(for: "Hong Kong International Airport", in: airportCodes)

// Ma se al posto di una String inserissimo una Struct o un oggetto?
// Sappiamo infatti che gli oggetti di default non aderiscono ad Equatable in quanto la loro
// struttura viene da noi definita.
enum Snack {
    case gum
    case cookie
}

struct Item {
    let price: Int
    let quantity: Int
}

// Per poter fare un simile uso del operatore ==, dobbiamo modificare il protocollo Equatable, che
// Equivale ad eseguire un Operator Overloading di ==, aggiungendo ad esso il supporto per oggetti di
// tipo Item:

extension Item: Equatable { // Estendiamo il protocollo.
    static func ==(lhs: Item, rhs: Item) -> Bool { // Overloading del operatore ==!
        return lhs.price == rhs.price && lhs.quantity == rhs.quantity
    }
}

let inventory: [Snack: Item] = [
    .gum: Item(price: 1, quantity: 5),
    .cookie: Item(price: 2, quantity: 3)
]

let someItem = Item(price: 2, quantity: 3)

findKey(for: someItem, in: inventory) // Funziona correttamente!

// Un altro esempio ma in questo caso chiunque sarà T dovrà soddisfare Comparable
func largest<T: Comparable>(in arrayOf: [T]) -> T? {
    
    var largestElement: T = arrayOf[0]
    
    for element in arrayOf {
        if largestElement < element {
            largestElement = element
        }
    }
    return largestElement
}

// Generic Types:

// Possiamo dichiarare un array come:

var arrayOfNumbers: [Int] = [] // Array vuoto

// Oppure:

var arrayOfNumbers2 = Array<Int>() // Gli Array in Background sono un Generic Type!

// Anche gli Optional:

// Possiamo dichiarare un optional nel classico modo:
var aString: String? = "Hello There"
// Oppure:
var streeName = Optional.some("1st Avenue")
// Se guardiamo la Documentation per il tipo Optional, ci accorgeremo subito che anche in questo caso
// ci troviamo dinnanzi ad un Generic Type abbastanza complesso.

// Anche i Dictionaries:

var errorCodes = Dictionary<Int, String>()
