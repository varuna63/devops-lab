def add(a, b):
    return a + b

def is_palindrome(text: str) -> bool:
    clean = "".join(ch.lower() for ch in text if ch.isalnum())
    return clean == clean[::-1]

if __name__ == '__main__':
    print(f"2 + 3 = {add(2, 3)}")
    print(f"racecar is palindrome: {is_palindrome('racecar')}")
