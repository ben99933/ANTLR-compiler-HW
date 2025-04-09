
int main() {
    int year;
    year = 100;
    bool is_leap_year;
    is_leap_year = false;
    if (year % 4 == 0) {
        if (year % 100 == 0) {
            if (year % 400 == 0) {
                is_leap_year = true;
            }
        } else {
            is_leap_year = true;
        }
    }
}
