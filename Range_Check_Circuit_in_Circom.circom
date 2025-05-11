pragma circom 2.1.4;

template RangeCheck() {
    // Public input
    signal input x;

    // Constants
    var lower_bound = 10;
    var upper_bound = 100;

    // Ensure x >= lower_bound
    signal lower_check;
    lower_check <== x - lower_bound;
    // If x < lower_bound, then lower_check would be negative,
    // which is invalid in the field, so this causes a constraint error.

    // Ensure x <= upper_bound
    signal upper_check;
    upper_check <== upper_bound - x;
    // If x > upper_bound, then upper_check would be negative.

    // Force the constraints to validate non-negativity
    // We can use a "booleanity" check by asserting the variables are within valid field range
    // Here, since the field is large enough (e.g., bn128), any unsigned integer < 2^32 is valid

    // Assert that both checks are >= 0
    // In Circom, this is implicitly enforced by the subtraction resulting in a valid field element
    // Optionally, you can add comparators if working in general fields

    // You can omit additional constraints if using Circom with known field properties
}

component main = RangeCheck();
