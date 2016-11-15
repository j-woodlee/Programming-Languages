/*
Quiz 2: Thursday

Topics:
    - Python and Java
    - Polymorphism: subtype and parametric
    - Subclassing and inheritance
    - Constraints/limitations/problems with each of
      subtyping, parametric poly., inheritance
    - Privacy: private, public, protected, default
    - Modularity in Java
    - Multiple inheritance
        - Java can only inherit from one class.
        - Can implement multiple interfaces that have default versions of the
        same method. Why/How?
*/

//solution: factor out the interface of rectangular things
interface Rectangular {
    void scaleWidth(int);
    void scaleHeight(int);
    void draw();
}

class Rectangle implements Rectangular {
    /// ...
}

class Square implements Rectangular {
    // Avoid having to copy/paste definitions from rectangle:
    private Rectangle r;

    void scaleWidth(int factor) {
        //use Rectangle's implementations
        // but preserve the invariant
        r.scaleWidth(factor);
        r.scaleHeight(factor);

    }
}

//Now, if we add addWidth method to rectangular,
// type checker will force us to implement it in square.
// have to write a bit of code to use Rectangle's implementation,
// but avoids the problems of automatic inheritance.

//Another issue.

class Bag {
    // aka multiset. like a set, but can have duplicates.
    Object[] elements;
    int size() {

    }
    void add (Object elem) {
        //...
    }
    void contains(Object elem) {
        //...
    }
}
//Now we want to add a Set class. Should Set extend Bag?
// Subclassing = subtyping + inheritance.
// inheritance:
// - Set can reuse Bag's implementation. Good!
// - Would want to override add, but inheriting the other
//   methods would make sense.
//Subtyping:
// - A set "is a" Bag, without duplicates
// - seems ok.

class Set extends Bag {
    void add(Object elem) {
        if(! this.contains(elem)) {
            super.add(elem);
        }
    }
}

class BagClient {
    void foo() {
        Bag bag = somewhere.getBag();
        int n = bag.size();
        bag.add("something");
        assert(bag.size() == n + 1);
    }
}

//Our intuition was off: a set isn't a bag!
// doesn't always behave like one.
// Bag Interface is not just the types of its methods;
// but also the behavioral "contract" guaranteed to the bag clients.
//Set does not follw the contract.
// So: Set should not be a subtype of Bag

// Inheritance sometimes makes sense without subtyping.
//Impossible in Java!

// Solution: factor out the code into a class "Collection"
//Interface doesn't provide any behavioral guarantees for its methods.
//Collection i sjust a repository for shared code.
class Collection {
    ///aka multiset. Like a set, but can have duplicats.
    Object[] elements;

    int size () {
        // ...
    }
    void add(Object elem) {
        // ....
    }
    boolean contains(Object elem) {
        // ....
    }
}

class Bag extends Collection {}
class Set extends Collection {}

// get code reuse, but can't us a set where a bag is expected.

// could make add abstract in Collection, so Set and Bag would
// be forced to implement it.
//
// can make elements private to reatain modularity for Collection

abstract class Collection {
    ///aka multiset. Like a set, but can have duplicats.
    Object[] elements;


    //only sublclasses get access to this
    protected void addForReal(Object elem);
    int size () {
        // ...
    }
    abstract void add(Object elem) {
        // ....
    }
    boolean contains(Object elem) {
        // ....
    }
}

//type checker forces Add and Set to implement add
// two problems: 1 can't access elements
//               2 code duplication!
class Bag extends Collection {
    void add(Object elem) {
        // do something
    }
}
class Set extends Collection {
    void add(Object elem) {
        //do something
    }
}

/*
Interfaces vs Abstract classes
- Neither can be instantiated
- Interfaces have no fields.
- Abstract classes can have fields
- An interface just declares a new type.
- An abstract class declares a new type, but also the beginning
    of a real class (but one that has holes in it)
*/
