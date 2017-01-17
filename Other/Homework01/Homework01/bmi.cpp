//  Puja Patel
//  ITP 165, Fall 2015
//  Homework 1
//  pujadpat@usc.edu

#include <iostream>
#include <string>

int main()
{
    //variables
    std::string Name;
    int heightFeet;
    int heightInches;
    int weightPounds;
    
    //user input
    std::cout << "Hello! Welcome to the BMI Calculator. Please tell me your name: ";
    std::cin >> Name; //save user input into variable Name
    std::cout << "Hi " << Name << "! Please tell me your height. Feet first: ";
    std::cin >> heightFeet; //save user input into variable heightFeet
    std::cout << "Inches: ";
    std::cin >> heightInches; //save user input into variable heightInches
    std::cout << "Thank you. Now please give me your weight in pounds: ";
    std::cin >> weightPounds; //save user input into variable weightPounds
    
    //calculations
    int overallHeight = heightFeet * 12 + heightInches; //calculate total height in inches
    //std::cout << overallHeight;
    double overallHeightMeters = double(overallHeight) / 39.3701; //convert height to meters
    //std::cout << overallHeightMeters;
    double Mass = double(weightPounds)/2.20462; //convert weight to kilograms
    //std::cout << Mass;
    double BMI = Mass / (overallHeightMeters * overallHeightMeters); //calculate BMI
    
    //output
    std::cout << Name << "'s BMI is " << BMI << "."; //output BMI
    
    //end nicely
    return 0;
}
