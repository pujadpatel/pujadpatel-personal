//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 20
//  pujadpat@usc.edu

#include "AddressBook.h"
#include <iostream>

AddressBook::AddressBook(unsigned int size)
{
    mCapacity = size;
    mUsed = 0;
    mContacts = new Contact[size];
}

void AddressBook::addContact(std::string& first, std::string& last, std::string& phone)
{
    mContacts[mUsed].mFirstName = first;
    mContacts[mUsed].mLastName = last;
    mContacts[mUsed].mPhone = phone;
    mUsed++;
}

void AddressBook::print()
{
    for (int i = 0; i<mUsed; i++)
    {
        std::cout << mContacts[i].mLastName << ", " << mContacts[i].mFirstName << ": " << mContacts[i].mPhone << std::endl;
    }
}
AddressBook::~AddressBook()
{
    delete[] mContacts;
}