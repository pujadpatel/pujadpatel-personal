//
//  hello.cpp
//  Hello
//
//  Created by Puja Patel on 8/22/15.
//  Copyright (c) 2015 PujaPatel. All rights reserved.
//
/* 
 #include specifies what library needs to be loaded in
 std::cout<<"Hello!"; also works
 Chaining: use addition << prior to the semicolon
 std::cout << "Hello" << "world!";
 
 To declare a variable, name with camelCase:
 - std::string for text
 ex: 
   std::string myName;
 use escape-sequences:
 ex:
   std::count << "\tThis text is indented." << std::endl;
 for varialbe reassignment, don't specify type:
 nyName = "Fred";
 
 Numeric Types:
 whole numbers- int
 real numbers- double
 use doubles for divition with remainders
 (int will truncate)
 
 Modulo:
 int x = 10 % 100;
 so x will equal 10
 so use modulo to check if a number is even or odd (equal to 1 or 0)
 
 int x = 10;
 x = x + 5
 or just use x += 5
 or x++ to increment 1
 
 int x = 5;
 std::cout << x * 2 << std::endl;
 this will return 10 but x stays 5
 
 casting allows us to forcibly convert types temporarily
 int x = 12;
 int y = 5;
 double a = double(x) / y;
 
 Bool type
 bool test= true;
 Use for comparisons:
 bool isFive = x == 5;
 == equal to
 != not equal to
 >, <, >=, <=
 || or
 && and
 bool trueBool = true, falseBool = false;
 
 Conditionals
 if (x>0)
 {
 }
 else
 {}
 -else if statements are mutually exclusive (only one will execute)
 
 Switch statement
 switch (select)
 {
 case 1:
   //option
   break;
 default:
   //invalid option;
   break;
 
 A scope starts at an opening brace and ends at the matching closing brace
 
 Loops
 int main()
 {
  int i = 0;
  while (i<5)
  {
    std::cout << "In loop!" <<std::endl;
    i++;
  }
  return 0;
 }
 a break statement will also exit the loop
 a continue will skip the remainder of the body for the current iteration
 do outer loops, test, then inner loops
 
 helpful: for a whole program in a loop, set a bool to true
 
 Do-While Loop: always executes at least once
 
 For Loop: for known number of iterations
 
 Loops have 3 degining features: initialization, condition, update
 
 Arrays
    std::string names[5];
    name[0]= "james";
 
 constant:
    const int num_students = 10;
 unsigned:
    a type modifier
    can only be >=0
 char:
    a whole number type that's represneted by a single byte
    so an unsigned char can range from 0 to 255
    ASCII: a standarized number code where every number corresponds to a specific letter
    difference between uppercase nd lovercase is 32
    char test = 'A' + 32 = a
    for an array of char's, add a 0 to the end
        char word[6]= {'H','E','L','L','O', 0]
        char word[6]="HELLO";
        char stuff[] = "I'm sorry";
 
 functions: can takine in parameters and perform a calculation
 functions that do not return values cannot be printed out directly
 comment function with:
 // Function: sayHello
 // Purpose: Outputs "hello" to cout.
 // Parameters: None
 // Returns: Nothing
 
 std::getline(std::cin, mySentence); saves input as mySentence
 to clear last enter for getline:
    std::cin.ignore();
 
 start hex numbers with a 0x
 
 
 structs
 -declared outside and before a function
 struct Contact
 {
    std::string firstName;
    std::string lastName;
    std::string phoneNumber;
 };
 you can access the varibles with a dot
    Contact testContact;
    testContact.firstName = "Toad";
 use pass by reference: 
    void printContact (Contact& contact)
*/
#include <iostream>
#include <string>

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!" << std::endl;
    std::string myName = "Raymond";
    std::cout << "My name is " << myName << std::endl;
    std::cout << "Input your name: \n";
    std::string yourName;
    std::cin >> yourName;
    if (yourName == "Puja")
    {
        std::cout << "Hello, " << yourName << std::endl;
    }
    else
    {
        std::cout << "GO AWAY";
    }
    std::cout << 0%2;
    std::cout<< 1%2;
    return 0;
}
