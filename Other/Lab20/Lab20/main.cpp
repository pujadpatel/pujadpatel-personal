//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 20
//  pujadpat@usc.edu

#include "AddressBook.h"
#include <iostream>

int main()
{
    std::string first ("Puja");
    std::string last ("Patel");
    std::string phone ("123-456-7890");
    
    AddressBook testBook(20);
    testBook.addContact(first, last, phone);
    
    first = "Doggy";
    last = "Ears";
    phone = "000-000-0000";
    
    testBook.addContact(first, last, phone);
    
    testBook.print();
    
    unsigned int a =32;
    unsigned int b = 8;
    unsigned int c =13;
    a = a << 1;
    b=b>>2;
    c=c>>3;
    std::cout << a <<std::endl;
    std::cout << b <<std::endl;
    std::cout << c <<std::endl;
    
    
    return 0;
}
