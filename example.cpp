#include <iostream>
use namespace std;

int main() {
    int i = 5;

    cout << i << endl;

    float f = i;                  // automatically converting i from an in
    cout << f << endl;            // to a float

    f = reinterpret_cast<float&>(i);
                            //we simply interpret the bit pattern of i
                            //as a float
                            //which float has the bit pattern for i?
    cout << f << endl;

    int * iptr = reinterpret_cast<int *>(i);
                                //reinterpret the bit pattern of i as
                                //a memory address. read from that address.
    //crash the program.
    //cout << *iptr << endl;

    iptr = &i; //treat i as the beginning of an array.
    cout << iptr[4] << endl; //garbage value
}
