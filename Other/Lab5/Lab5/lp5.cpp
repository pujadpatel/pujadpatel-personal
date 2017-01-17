//  Puja Patel
//  ITP 365, Fall 2016
//  Lab 5
//  pujadpat@usc.edu
//  Platform: Mac

#include <iostream>
#include <list>

// Function: printList
// Purpose: prints out list of ints
// Input: the list to be printed
// Output: none
void printList(std::list<int>& list){
    std::cout << "{";
    for (int n : list){
        std::cout << n << " ";
    }
    std::cout << "}" <<std::endl;
}

int main(int argc, const char * argv[]) {
    std::list<int> nums;
    std::list<int>::iterator i = nums.begin();
    
    for (int j =0; j<=9; j++){
        nums.push_back(j*2);
    }
    
    std::cout << "Beginning list..." <<std::endl;
    printList(nums);
    
    std::cout << "After insert @ begin..." << std::endl;
    i++;
    nums.insert(i,100);
    printList(nums);
    
    std::cout << "After one insert @ 1st half..." << std::endl;
    i++;
    i++;
    i++;
    nums.insert(i,101);
    printList(nums);
    
    std::cout << "After double insert @ 2nd half..." <<std::endl;
    i++;
    i++;
    i++;
    i++;
    nums.insert(i,102);
    nums.insert(i,103);
    printList(nums);
    
    std::cout << "Insert at end..." << std::endl;
    i++;
    i++;
    i++;
    nums.insert(i,104);
    printList(nums);
    
    return 0;
}
