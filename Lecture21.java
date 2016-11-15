/*
Last: two kinds of polymorphism

What can we do with parametric?
    - define functions and data types that are *parametric*
      in a type. We treat those uniformly.
      e.g. Set<T> can contain elements of any type.
        - and all elements have that type.

What can we do with subtyping?
    -  establishes an "is a" relationship betweent types.
    - ListSet "is a" Set
      ArraySet "is a" Set
    - Defined union that operates on any two sets.

Key Difference:
    - with subtyping, we know *something* about the type.
    - with parametric, we know *nothing* about the type.

Suppose we want to implement RemovableSet.
    - need remove
    - also need contains and addElem to satisfy the subtyping constraint
*/

/*
When one class A extends another B.

- It establishes a subtyping relationship A <= B
    - wherever a B is expected, we can use an A.
    - a *typing* or *interface* concern

- Reuses the code from B in A
    - an *implementation* concern

We have the following subtyping relationships:

        RemovableListSet <= ListSet
        RemovableListSet <= RemovableSet
        RemovableListSet <= Set (by transitivity of subtyping)

*/

interface A { void foo();}
class B implements A {void foo() {}}
class C implements A {void foo(){System.exit(1);}}
class D extends B, C {}

/*
This is not allowed in Java.
- Which implementation of foo should D inherit?
- called *the diamond problem*
- other languages do allow this.

*/
//Java 8 allows interfaces to provide default implementations of methods.
// We've already seen that a class can implement multiple interfaces.

interface A {void foo();}
interface B extends A {
    default void foo() {};
}

interface C extends A {
    default void foo() { System.exit(1);}
}

class D implements B, C {
    //Looks like multiple inheritance
    public void foo() {
        B.super.foo(); //use implementation from B
        //this is allowed in Java.
    }
}

//So the diamond problem (the motivation for banning MI in Java)
//is not too bad for methods.

class B {
    int foo;
    //...
}
class C {
    String foo;
}

class D extends B,C {
    //which food do we get?
    //no easy way to resolve conflicts between the types of foo
    //used in B and C.
    // if we choose int, we break C etc.
}

/*
So MI is a bigger problems for class than interfaces even with default
method implementations.
 - why? because ... classes have fields.

 So MI is banned in Java, but allowed in other languages.
    - notably C++
*/

/*
Java has a special class called Object.
    - all classes ultimately inherit from Object
    - all types of objects are subtypes of Object
    - why is it there?
        - it provides default implementations of methods that are
          are generally useful.
          - toString
          - equals() pointer equality
          - hashCode()
      -before generics, containers always used Object for their element type.

*/

/*
Privacy:
    - three levels of privacy on fields and methods: public, protected, and private.
        - public: can be accessed from anywhere
        - protected: can be accessed from subclasses
        - private: can be accessed from only this class.

class ListSet implements Set {
    private List<String> elems;
    ListSet() {

    }
}
class RemovableList extends ListSet implements RemovableSet {
    // ...
}

Can be tricky deciding what to make public, private, or protected.

Balance the need for information hiding etc.
    with the potential need for reuse via sublassing.

*/

/*
Subtyping vs subclassing
In Java they are conflated, easy to mix up.
 - is they often introduced simultaneously

 But there are cases where we want to subtype without subclassing.
 Example: Rectangles and Squares.
*/

class Rectangle {
    private int x, int y, int width, int height;
    Rectangle() {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    void move(int dx, int dy) {
        this.x += dy;
        this.y += dy;
    }
    void scaleWidth(int factor) {
        this.width *= factor;
    }
    void scaleHeight(int factor) {
        this.height += factor;
    }
    void draw() {
        // ..
    }
}

class Square extends Rectangle {
    //private int x, int y
    Square(int x, int y, int width) {
        super(x,y,width,width);
    }
    //inherit everything from Rectangle
    //scaleWidth and scaleHeight can break the invariant.
    void scale(int factor) {
        super.scaleWidth(factor);
        super.scaleHeight(factor);
    }
    void scaleWidth(int factor) {
        this.scale(factor);
    }
    void scaleHeight(int factor) {
        this.scale(factor);
    }
}
//problem solved!
//... or is it?

//what if we want to add a method addWidth(int) or addHeight(int)?
// - we have to remember to fix square again!
// - this goes against the philosophy of Java and OOP
// - implementers of a class shouldn't have to worry about breaking
//   subclasses.  Too many of them, new ones added at any time.

//Moral: sometimes we want subtyping without subclassing(inheritance).
//How do we get that? interfaces! (next time)
//
