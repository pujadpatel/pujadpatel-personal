//  Puja Patel
//  ITP 165, Fall 2015
//  Lab Practical 17
//  pujadpat@usc.edu

#include <iostream>
#include <fstream>

void printArrwithAddy (int array[], int size)
{
    for (int i=0; i<size; i++)
    {
        std::cout << i << " = " << array[i] << " @ " << &array[i] <<std::endl;
    }
}

int getMax(int array[], int size)
{
    int max = 0;
    for (int i=0; i<size; i++)
    {
        if (array[i] > max)
        {
            max = array[i];
        }
    }
    return max;
}

int main()
{
    std::string filein;
    const int size = 100;
    
    std::cout << "File name: ";
    std::cin >> filein;
    std::ifstream fileInput (filein);
    int array[size];
    int counter = 0;
    int temp;
    if (fileInput.is_open())
    {
        std::cout << "Printing array contents and addresses..." <<std::endl;
        while (fileInput.eof() != true && counter<size)
        {
            
            fileInput >> temp;
            array[counter] = temp;
            counter+=1;
            
        }
    }
    else
    {
        std::cout << "File not found" <<std::endl;
    }
    
    printArrwithAddy(array, size);
    
    std::cout << "Max value is: "<< getMax(array, size);
    
    return 0;
}
