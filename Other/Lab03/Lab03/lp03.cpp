// Puja Patel
// ITP 165, Fall 2015
// Lab practical 3
// pujadpat@usc.edu


#include <iostream>

int main()
{
    //variables
    double firstOperand, secondOperand, result;
    int option;
    
    //user input
    std::cout << "Calculator:" << std::endl;
    std::cout << "Please enter the first input: ";
    std::cin >> firstOperand;
    std::cout << "Please enter the second input: ";
    std::cin >> secondOperand;
    
    //options menu
    std::cout << "Choose an option:" << std::endl;
    std::cout << "\t1. Add\n\t2. Subtract\n\t3. Multiply\n\t4. Divide\n";
    std::cin >> option;
    
    //calculations
    switch (option)
    {
        case 1:
            result = firstOperand + secondOperand;
            std::cout << firstOperand << " + " << secondOperand << " = " << result;
            break;
        case 2:
            result = firstOperand - secondOperand;
            std::cout << firstOperand << " - " << secondOperand << " = " << result;
            break;
        case 3:
            result = firstOperand * secondOperand;
            std::cout << firstOperand << " * " << secondOperand << " = " << result;
            break;
        case 4:
            if (secondOperand == 0)
            {
                std::cout << "You cannot divide by zero." <<std::endl;
            }
            else
            {
            result = firstOperand / secondOperand;
            std::cout << firstOperand << " / " << secondOperand << " = " << result;
            }
            break;
        default:
            std::cout << "You entered an invalid option. Please input a number 1 to 4.";
    }
    //output
    return 0;
}
