/*

News:
  - midterm grades today or tomorrow.
  - quiz 2 a week from thursday (11/17)
    - python and java.
  - hw7 posted saturday

Last time:
  - JAVA

*/

/*
Modularity: protecting components from each other.
  - enforcing the boundary between components
  - separate interface from implementation
  - loose coupling
    - two components coupled in the sense that they depend upon each other
      for some functionality
    - loosely, so one component can easily be replaced by another
Modularity:
  - enables parallel development
  - enables code reuse
  - makes code more flexible, adaptable, robust to change.
  - makes code more understandable, by enabling local reasoning.
*/

/*
Java supports two kinds of polymorphism:
  1) parametric polymorphism
    - called generics in Java
    - called polymorphism in OCaml
    - Idea: a type can have a parameter by *type variables*

    List<String> listOfString;
    List<Shape>  listOfShapes;

Example from OCaml:

  type 'a option = None | Some of 'a
  applyInOption : ('a -> 'b) -> 'a option -> 'b option
  applyInOption f x =
    match x with:
    | None -> None
    | Some a -> Some (f a)

We can make our Set interface polymorphic in the element type.
*/

interface Set<T> {
  boolean contains(T s);
  void addElem(T s);
}

//Set<T> is like 'a option
//T is a type variable in Java, where 'a is type variable in OCaml

/*
Set<String> s1 = ...
s1.add("hello");
Set<Shape> s2 = ...
s2.addElem(new Square());

s2.addElem("hello"); //static type error
*/

/*
Implementations of a parametric interface like Set<T> can be
parametric or not:
*/

class ListSet<T> implements Set<T> {
    List<T> elems;
    // ...
}

class StringListSet implements Set<String> {
  List<String> elems;
  // ...
}

/*
Second kind of polymorphism: subtype polymorphism.
*/
interface RemovableSet extends Set<String> {
    void remove(String s);
}

/*
RemovableStringSet supports all the operations of Set<String>
  ... and void remove(String)

  This establishes a *subtype relationship* between RemovableStringSet and
    - key idea: *subtype substitutability*
      - anywhere a Set<String> is expected, a RemovableStringSet can be used
      - anywhere some type is expceted, a *subtype* of that type can be used
    - if X "implements" or "extends" Y, then X <= Y
    - read: "X is a subtype of Y" or "X is a Y"
    - anywhere a Y is expected, an X can be used.
    - because X supports all the oeprations of Y
    - a function expecting a Y is polymorphic over all subtypes of Y
    - as with parametric polymorphism, we have one function that
      can be used with arguments of many possible different types.

*/

class ListRemovableStringSet implements RemovableStringSet {
  // ...
}

// ListRemovableStringSet  <= RemovableStringSet <= Set<String>
// subtyping is transitive!

class Client{
    Set union(Set<String> s1, Set<String> s2) {
        // ..
    }
}

//subtype polymorphism allows many different combinations of
// types of s1 and s2.
// - that's a lot harder to do with param. poly. alone

class Client {
    void test(RemovableSet rs) {
        Set<String> s = rs; //Legal by subtype polymorphism
        s.addElem("Hello");//OK
        rs.remove("Hello");//OK
        s.remove("Hello");//type error: Set<String> does not have remove
        rs = s; // type error: s is not known (by only looking at the declared type of s) to be a
                // a RemovableStringSet.
                // RemovableStringSet is a (subtype of) Set<String>
                //"Set<String>" is a "RemovableStringSet" is false.
    }
}

/*
Subtyping is not symmetric.
    if X <= Y, it's not necessarily true that Y <= X.
*/

// it's possible to combine parametric and subtype polymorphism

interface ListRemovableSet<T> extends Set<T> {
    // ...

}

/*
Set s = rs; // looks like a coercion/conversion
  - does not change the underlying data at all.

In Java:

double x = 2;
    - convert between types can introduce imprecision

Automatic conversion can look like a kind of polymorphism
    void f(double x) {
    f(4.5)
    f(12)
    }
int is NOT a subtype of double
    - they have different representation and different operations
    - conversion introduces loss of precision

    automatic conversion is just a convenience
*/

// Why have two kinds of polymorphism at all? in the same language?
// - they are incomprable or orthoganal.
// - each can do things the other cannot

// Consider union:
class Client {
    <T> void union(T s1, T s2) {
        // stuck: we don't even know that T is a set.
    }
}

//So subtype polymorphism is good.
//What can parametric polymorphism do that subtype polymorphism can't?

//Why is this:
interface Set<T> {
    void add(T e);
    boolean contains(T e);
}
//better than:

interface ObjectSet {
    void add(Object o);
    boolean contains(Object o);
    List<Object> getElems();
}

class SetClient {
    Program pgms = // ...
    for (Program p : pgms.getElems()) {
        p.run();
    }
}


class SetClient {
    ObjectSet pgms = // ...
    for (Object p : pgms.getElems()) {
        Program p = (Program) o; //downcast could fail, b/c o could possible not be a Program
        p.run();
    }
}

/*
Parametric polymorphism helps us avoid errors.
    - giving us more precise types
    - can't put a shape into a Set<Program>
    - eliminates annoying boilerplate casting and error handling

Generics added to Java 1.5 for this reason.

*/
