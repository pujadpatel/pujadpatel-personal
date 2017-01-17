//  Puja Patel
//  ITP 165, Fall 2015
//  Homework 2
//  pujadpat@usc.edu


#include <iostream>
#include <string>
#include <cmath>

int main ()
{
    //variables
    double purchasePrice, downPayment, salesTax, tradeInValue, amountOwed, totalDownPayment, loanAmount, percentDown, interestRate, monthlyInterest, monthlyPayment, numberOfPayments;
    int option;
    std::string tradeIn;


    //Part 1: Down Payment
    //user input
    std::cout << "Hello! Welcome to Vehicle Loan Payment Calculator.\nPlease enter the vehicle's purchase price: ";
    std::cin >> purchasePrice;
    std::cout << "Enter the down payment for the vehicle: "; //stores user input into variable
    std::cin >> downPayment;
    std::cout << "Enter the sales tax on the transaction (for 8.25%, enter 8.25): ";
    std::cin >> salesTax;
    std::cout << "Do you have a vehicle to trade in? (y/n): ";
    std::cin >> tradeIn;
    //If vehicle is going to be traded in, more input is needed
    if (tradeIn == "Y" || tradeIn == "y")
    {
        std::cout << "Enter the vehicle's current trade in value: ";
        std::cin >> tradeInValue;
        std::cout << "Enter the amount that is owed on the vehicle: ";
        std::cin >> amountOwed;
    }

    //calculations
    totalDownPayment = downPayment + (tradeInValue - amountOwed);
    std::cout << "Your overall down payment is $" << totalDownPayment << std::endl;
    loanAmount = (purchasePrice -totalDownPayment) * (1 + (salesTax/100));
    std::cout << "Your overall loan amount is $" << loanAmount << std::endl;
    std::cout << "*****************************" << std::endl;
    
    //Part 2: Number of Payments
    //options menu
    std::cout << "Enter the length of your loan:" << std::endl;
    std::cout << "\t1: 3 years\n\t2: 4 years\n\t3: 5 years\n\t4: 6 years\n";
    std::cout << "Select an option: ";
    std::cin >> option;
    //calculations
    switch (option)
    {
        case 1:
            numberOfPayments = 36;
            std::cout << "You selected a 3 year loan with 36 monthly payments." << std::endl;
            break;
        case 2:
            numberOfPayments = 48;
            std::cout << "You selected a 4 year loan with 48 monthly payments." << std::endl;
            break;
        case 3:
            numberOfPayments = 60;
            std::cout << "You selected a 5 year loan with 60 monthly payments." << std::endl;
            break;
        case 4:
            numberOfPayments = 72;
            std::cout << "You selected a 6 year loan with 72 monthly payments." << std::endl;
            break;
        default:
            numberOfPayments = 60;
            std::cout << "You selected a 5 year loan with 60 monthly payments." << std::endl;
    }
    std::cout << "*****************************" << std::endl;

    //Part 3: Interest Rates
    percentDown = totalDownPayment/purchasePrice;
    // nested conditionals to determine interest rate
    if (percentDown < 0.20)
    {
        if (option == 1)
        {
            interestRate = 4.00;
            std::cout << "With " << percentDown*100 << "% down and a 3 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else if (option == 2)
        {
            interestRate = 4.33;
            std::cout << "With " << percentDown*100 << "% down and a 4 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else if (option == 3)
        {
            interestRate = 4.66;
            std::cout << "With " << percentDown*100 << "% down and a 5 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else if (option == 4)
        {
            interestRate = 5.00;
            std::cout << "With " << percentDown*100 << "% down and a 6 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else
        {
            interestRate = 4.66;
            std::cout << "With " << percentDown*100 << "% down and a 5 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
    }
    else if (percentDown >= 0.20)
    {
        if (option == 1)
        {
            interestRate = 3.70;
            std::cout << "With " << percentDown*100 << "% down and a 3 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else if (option == 2)
        {
            interestRate = 3.80;
            std::cout << "With " << percentDown*100 << "% down and a 4 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else if (option == 3)
        {
            interestRate = 3.90;
            std::cout << "With " << percentDown*100 << "% down and a 5 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else if (option == 4)
        {
            interestRate = 4.00;
            std::cout << "With " << percentDown*100 << "% down and a 6 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
        else
        {
            interestRate = 3.90;
            std::cout << "With " << percentDown*100 << "% down and a 5 year loan, we can offer you an interest rate of " << interestRate << "%" << std::endl;
        }
    }
    std::cout << "*****************************" << std::endl;

    //Part 4: Monthly Payment Calculation
    monthlyInterest = interestRate/1200;
    monthlyPayment = loanAmount * (monthlyInterest/(1- std::pow(1+monthlyInterest,-(numberOfPayments))));
    std::cout << "Your estimated monthly payment would be $" << monthlyPayment <<" a month.";
    
    //end
    return 0;
}
