//  Puja Pattel
//  ITP 165, Fall 2015
//  Homework 8
//  pujadpat@usc.edu

#include <iostream>
#include <fstream>
#include <string>

//sets up Elephant class
class Elephant
{
private: //private member variables
    int mHunger;
    int mHappiness;
    std::string mName;
public: //public member functions
    void setmHunger(int newmHunger)
    {
        mHunger = newmHunger;;
    }
    int getmHunger()
    {
        return mHunger;
    }
    void setmHappiness (int newmHappiness)
    {
        mHappiness = newmHappiness;
    }
    int getmHappiness()
    {
        return mHappiness;
    }
    void setmName (std::string newmName)
    {
        mName = newmName;
    }
    std::string getmName ()
    {
        return mName;
    }
    //  Function: PrintStats
    //  Purpose: prints out the stats of the elephant
    //  Parameters: none
    //  Returns: none
    void PrintStats()
    {
        std::cout<<"********************************"<<std::endl;
        std::cout<<"Name: "<< mName <<std::endl;
        std::cout<<"Hunger: " <<mHunger << std::endl;
        std::cout<<"Happiness: "<< mHappiness <<std::endl;
        std::cout<<"********************************"<<std::endl;
    }
    //  Function: Play
    //  Purpose: plays with elephant; increases happiness by 10 and decreases hunger by 5
    //  Parameters: none
    //  Returns: none
    void Play()
    {
        std::cout << "YAY you played with your elephant!" <<std::endl;
        mHappiness+=10;
        mHunger+=5;
    }
    //  Function: feed
    //  Purpose: feeds the elephant; decreases hunger by 10
    //  Parameters: none
    //  Returns: none
    void Feed()
    {
        std::cout<<"Yummy! You fed your elephant!" <<std::endl;
        mHunger-=10;
    }
};

int main()
{
    //initialize variables
    Elephant elephant; //creates an object of Elephant
    int hunger = 0;
    int happiness = 0;
    std::string name;
    int userInput = 1;
    std::string filein;
    std::string fileout;
    
    /*Testing
     elephant.setmName("Elly");
     elephant.PrintStats();
     elephant.setmHappiness(100);
     std::cout << elephant.getmHappiness() <<std::endl;
     elephant.PrintStats();
     elephant.Play();
     elephant.PrintStats();
     elephant.Feed();
     */
    
    std::cout << "What is the input file? ";
    std::cin >> filein;
    std::ifstream fileInput (filein); //creates input file stream
    
    if (fileInput.is_open()) //file is open
    {
        while (fileInput.eof() != true) //not reached end of file
        {
            //reads in input file
            fileInput >> hunger;
            fileInput.ignore();
            fileInput >> happiness;
            fileInput.ignore();
            std::string line;
            std::getline(fileInput,line);
            name = line;
            
            //sets variables for elephant
            elephant.setmName(name);
            elephant.setmHappiness(happiness);
            elephant.setmHunger(hunger);
            fileInput.ignore();
        }
        fileInput.close();
    }
    else //if file does not open
    {
        std::cout << "Unable to open file." <<std::endl << "Quitting...";
        return 0;
    }
    
    while (userInput != 0) //user wants to continue
    {
        //options menu
        std::cout << "\t1. Play with your elephant?\n\t2. Feed your elephant?\n\t3. Rename elephant?\n\t4. Print stats of your elephant?\n\t5. Save and quit?" << std::endl;
        std::cout << "What would you like to do with your elephant? ";
        std::cin >> userInput;
        
        switch (userInput) //switch statement for options menu
        {
            case 1: //elephant gets played with
                elephant.Play();
                break;
            case 2: //elephant gets fed
                elephant.Feed();
                break;
            case 3: //elephant gets new name
                std::cout << "New Name: ";
                std::cin >> name;
                elephant.setmName(name);
                break;
            case 4: //prints out elephant stats
                elephant.PrintStats();
                break;
            default: //saves elephant stats to an output file
                std::cout << "Time to save your elephant!" << std::endl;
                std::cout << "What is the output file? ";
                std::cin >> fileout;
                std::ofstream fileOutput (fileout); //creates output stream
                if (fileOutput.is_open())
                {
                    fileOutput << elephant.getmHunger() <<std::endl;
                    fileOutput << elephant.getmHappiness() <<std::endl;
                    fileOutput << elephant.getmName() <<std::endl;
                    std::cout << "Saved your elephant to " << fileout << std::endl;
                    std::cout << "Quitting...";
                    fileOutput.close();
                    return 0;
                }
        }
    }
    return 0;
}

