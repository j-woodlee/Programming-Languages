/*

Java.
*/

class JavaTime {
  public static void main(String[] args) {
    System.out.println("Java time.");
  }
}

// Fundamental improvements from other languages:
// Strong typing. aka type safety
// Garbage collection
// Before Java, thought to be impractical
// After Java, pretty much standard

//Object orientation:
// - Classes
//    - collection of methods shared by a group of objects
//    - Abstract data type
//      - blueprint for objects
// - Inheritance.
//   - Classes, prototypes
//    - Code reuse.
//    - Take (inherit) some existing code, change it in some way
// - Objects
//    - bundle of some state and some functions that operate on that state
// - Subtyping (polymorphism)
//    - classes, interfaces
// Note:
// - classes andn interfaces are not essential for OOP
// - JS, Python, Ruby, don't have interfaces
//    - interfaces there for static type checking
// - Classes are only one way of getting code reuse
//  - prototypes (JS, self)
// - objects are the only essential idea!

/*
Generics:
  - Parametric polymorphism (from FP)
    append : 'a list -> 'a list -> 'a list

    'a is a type parameter
        all occurences can be replaces by some type.

    append : F('a) = 'a list -> 'a list -> 'a list

    List<Integer>
    List<A>

  - Java made Parametric polymorphism mainstream.

Other high-level features:
  - concurrency, first-class functions

Really nice tools:
  - IDEs, debuggers, build systems, package managers, code analyzers.

OO decomposes programs into objects that communicate with each other by sending *messages*.
  - Instead of calling a function f(x)
  - send a message "f(x)" to an object: o.f(x)
  - what's the difference between f(o,x) and o.f(x)?
  - the "reciever" o decides what "f(x)"
  - extra layer of indirection adds a lot of flexibility
  - the meaning of "f" is "bound" as late as possible.

Messages are also called "methods" or "member functions" in OO terminology.

Messages sends not always "synchronous"
 - synchronous: wait for the reponse (return value)
 - asynchronous: keep running

 Objects are about separating interface from implementation.
    - objects have some *internal* state that only they themselves can access
    - clients have to send messages to the objects
    - the idea of a public member variable goes against philosophy of OOP
    - but people do it anyway, for performance and/or convenience

Why separate interface from implementation?
 - implementation flexibility.
 - Information hiding / encapsulation. Security.
 - Modularity.
    - Modular type checking / separate compilation.
    - check once that an implementation meets its interface
    - Separately check that clients meet the interface
    - then we can safely compose the client and the implementation.

All three of these are critical for *component-based programming*:
  - People produce libraries or component
  - validate them once
  - can be safely used by clients
  - can be safely modified/upgraded later

*/

interface Set {
  boolean contains(String s);
  void addElem(String s);
}

/*
Also part of the "interface" but not expressible in Java

Set s = ...;
s.addElem("hey")
s.contain("hey") == true;


Other languages have more expressive facilities for these kinds of behavioral properties, e.g. contracts.
But in Java, we instead write unit tests.

We can later implement this interface.

If a class SomeSet implements Set, then:
  - if o has type SomeSet then o also has the type Set.
  - if o has type Set, it *may* or *may not* have type SomeSet.

An interface defines a new type.
 - same name as the name of the interface.
 - object of type Set are receivers for contains and addElem
 - interfaces cannot have any implementation
  - no actual methods, no fields
*/

class Client {
    void myClient(Set s) {
      s.addElem("hi");
      if(!s.contains("hi")) {
        System.out.println("Wat!");
      } else {
        System.out.println("Cool.");
      }
    }
}

class ListSet implements Set {
    private List<String> elems;
    ListSet() {
        elems = new LinkedList<String>();
    }
    boolean contains(String s) {
        return elems.contains(s);
    }

    void addElem(String s) {
        if(! this.elems.contains(s)) {
          this.elems.add(s);
        }
    }
}

class TestListSet {
    public static main void(String[] args) {
        Client c = new Client();
        ListSet s = new ListSet();
        
    }
}
