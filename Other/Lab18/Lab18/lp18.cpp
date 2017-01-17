//  Puja Patel
//  ITP 165, Fall 2015
//  Lab Practical 18
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
    
    int* a = nullptr;
    int size = 0;
    std::string filein;
    
    std::cout << "File name: ";
    std::cin >> filein;
    std::ifstream fileInput (filein);

    if (fileInput.is_open())
    {
        std::cout << "Printing array contents and addresses..." <<std::endl;

            fileInput >> size;
            a = new int[size];

            for (int i = 0; i < size; i++)
            {
                fileInput >> a[i];
            }
    }
    
    else
    {
        std::cout << "File not found" <<std::endl;
    }
    
    printArrwithAddy(a, size);
    
    std::cout << "Max value is: "<< getMax(a, size);
    
    delete[] a;
    
    return 0;
}
