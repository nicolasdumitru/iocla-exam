#include <stdio.h>
#include <stdint.h>

uint8_t calculate_time_jump(uint8_t currentYear, uint8_t destinationYear) {
    // TODO a: Determine the correct value of timeJump to reach destinationYear
    // Because the timeline acts within a single byte length [0, 255] (256 units),
    // subtracting the two uint8_t variables will automatically underflow and compute 
    // the correct required circular time jump interval.
    // e.g. 20 - 250 = -230 = 26 in unsigned 8-bit math.
    // currentYear (250) + time_jump (26) = 276 = 20 (mod 256).
    return destinationYear - currentYear;
}

void test_time_jump() {
    uint8_t currentYear = 250;
    uint8_t destinationYear = 20;
    uint8_t timeJump = calculate_time_jump(currentYear, destinationYear);

    currentYear += timeJump;
    printf("The ship has arrived in the year: %d\n", currentYear);

    if (currentYear == destinationYear) {
        printf("Mission successful! We arrived at the destination in year %d.\n", destinationYear);
    } else {
        printf("Oops! Something's wrong. We landed in year %d.\n", currentYear);
    }
}

// TODO b: Rearrange the structure to save memory
// Rearranging in decreasing variable size strictly removes memory padding between attributes.
// The optimal memory alignment order is: 8-byte, 4-byte, 2-byte, then 1-byte entries.
struct SpaceColony {
    double energy_reserve;     // 8 bytes
    double defense_rating;     // 8 bytes
    int *useless_entry;        // 8 bytes (or 4 bytes) depending on x86/x64
    uint32_t id;               // 4 bytes
    uint32_t resource_count;   // 4 bytes
    uint16_t security_level;   // 2 bytes
    uint16_t alliance_id;      // 2 bytes
    char name[17];             // 17 bytes
    char commander[8];         // 8 bytes
    char coordinates[5];       // 5 bytes
    uint8_t sector_type;       // 1 byte
    uint8_t is_inhabited;      // 1 byte
    uint8_t status_flags;      // 1 byte
};

void test_space_colony() {
    struct SpaceColony colony = {
        .id = 1,
        .name = "Alpha Centauri",
        .energy_reserve = 100.0,
        .sector_type = 1,
        .commander = "Zara",
        .security_level = 3,
        .is_inhabited = 1,
        .resource_count = 120,
        .coordinates = "A3",
        .alliance_id = 42,
        .status_flags = 0xFF,
        .defense_rating = 5.5
    };

    printf("Memory used by colony: %zu bytes\n", sizeof(colony));
}

// TODO c: Implement the function using ONLY goto and if (no for, while)
void detect_anomalies(int16_t* signals, uint8_t length, uint8_t* anomalies) {
    uint8_t i = 0;

loop_start:
    if (i == length) {
        goto end;
    }
    // Condition checks: less than 0 or greater than 100
    if (signals[i] < 0) {
        goto increment;
    }
    if (signals[i] > 100) {
        goto increment;
    }
    
    // Valid signal, skip incrementing
    goto next;

increment:
    (*anomalies)++;

next:
    i++;
    goto loop_start;

end:
    return;
}

void test_detect_anomalies() {
    int16_t signals[] = {50, 75, -30, 120, 60, -10, 200, 45};
    uint8_t anomalies = 0;
    detect_anomalies(signals, 8, &anomalies);
    printf("Anomalies detected: %d\n", anomalies);
}

int main() {
    test_time_jump();
    test_space_colony();
    test_detect_anomalies();
    return 0;
}
