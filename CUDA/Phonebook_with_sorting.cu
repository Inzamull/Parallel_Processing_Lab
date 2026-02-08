%%writefile p2_colab_fixed.cu

#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <sstream>
#include <cctype>
#include <cstring>

using namespace std;

// Contact structure
struct Contact {
    string name;
    string phone;
};

// Convert string to lowercase
string toLower(const string &s) {
    string res = s;
    for(auto &c : res) c = tolower(c);
    return res;
}

// Check if 'pattern' is substring of 'text', case-insensitive
bool contains(const string &text, const string &pattern) {
    string txt = toLower(text);
    string pat = toLower(pattern);
    return txt.find(pat) != string::npos;
}

int main() {
    // Colab path
    ifstream file("/content/input.txt");
    if(!file) {
        cout << "ERROR: /content/input.txt not found!\n";
        return 0;
    }

    vector<Contact> phonebook;
    string line;

    // Read file line by line
    while(getline(file, line)) {
        if(line.empty()) continue;

        size_t last_space = line.rfind(' ');
        if(last_space == string::npos) continue;

        string name = line.substr(0, last_space);
        string phone = line.substr(last_space + 1);

        phonebook.push_back({name, phone});
    }

    if(phonebook.empty()) {
        cout << "No contacts loaded!\n";
        return 0;
    }

    // Input search term
    string search;
    cout << "Enter search term: ";
    getline(cin, search);

    // Collect matches
    vector<Contact> matched;
    for(auto &c : phonebook) {
        if(contains(c.name, search)) matched.push_back(c);
    }

    // Sort ascending by name
    sort(matched.begin(), matched.end(), [](const Contact &a, const Contact &b){
        return a.name < b.name;
    });

    // Print results
    cout << "\nSEARCH RESULTS (SORTED):\n";
    cout << "---------------------------------\n";

    if(matched.empty()) {
        cout << "No match found\n";
    } else {
        for(auto &c : matched) {
            cout << c.name << " -> " << c.phone << endl;
        }
    }

    cout << "---------------------------------\n";
    cout << "Total Matches: " << matched.size() << endl;

    return 0;
}
//!nvcc p2_colab_fixed.cu -o p2
//!./p2 input.txt "SALMA" 256