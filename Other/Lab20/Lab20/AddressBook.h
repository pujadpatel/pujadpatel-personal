//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 20
//  pujadpat@usc.edu

#pragma once
#include <string>

struct Contact
{
    std::string mFirstName;
    std::string mLastName;
    std::string mPhone;
};

class AddressBook
{
private:
    int mCapacity;
    int mUsed;
    Contact* mContacts;
public:
    AddressBook(unsigned int size);
    void addContact(std::string& first, std::string& last, std::string& phone);
    void print();
    ~AddressBook();
};