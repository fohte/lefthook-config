#!/bin/bash
# Test script to verify shell linting

function test_function() {
    echo "Testing"
    local  var="test"
if [ "$var" = "test" ]; then
        echo "Success"
fi
}

test_function
