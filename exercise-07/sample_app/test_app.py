import pytest
from app import add, is_palindrome

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0

def test_palindrome():
    assert is_palindrome("racecar") is True
    assert is_palindrome("Madam, I'm Adam") is True
    assert is_palindrome("hello world") is False
