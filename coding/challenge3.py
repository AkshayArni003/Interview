import sys
import random


def create_test_cases(test_case_count):
    """
    :param test_case_count: is used to generate number of test cases that is required. If 10 is passed 10 different
            test cases is generated.
    :return: List of list which consists of object in first index and keys in second index
            [[{'i': {'h': {'y': {'b': 'i'}}}}, 'i/h/y/b/i']]
    """
    alphabets = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
                 't', 'u', 'v', 'w', 'x', 'y', 'z']
    test_cases = []
    for count in range(test_case_count):
        keys, nested_obj = "", {}
        objects = nested_obj
        object_keys_count = random.randint(3, 10)
        keys = "/".join([(i, random.choice(alphabets))[1] for i in range(object_keys_count)])
        final_keys = ""
        keys_iterator = keys.split("/")
        for index, char in enumerate(keys_iterator):
            if index == len(keys_iterator) - 2:
                objects[char] = keys_iterator[index + 1]
            else:
                final_keys += char + "/"
                objects[char] = {}
            if index == len(keys_iterator) - 2:
                objects = objects[char]
                break
            else:
                objects = objects[char]
        test_cases.append([nested_obj, final_keys])
    return test_cases


def get_nested_object_value(nested_object, keys):
    """
    :param nested_object: Nested object against which the value has to be found.
    :param keys: String of keys which has to be used to find the value for from the nested object.
    :return: String or object based on the value of the last key in the keys.
    """
    keys = keys.split("/")
    obj = None
    for key in keys:
        if obj:
            obj = obj[key]
        else:
            obj = nested_object[key]
    return obj


def main():
    test_case_count = int(sys.argv[-1])
    test_cases_list = create_test_cases(test_case_count)
    for test_case in test_cases_list:
        keys_len = random.randint(1, len(test_case[1]))
        query_keys = test_case[1][:keys_len]
        # Generating dynamic length of keys
        query_keys = query_keys if query_keys[-1] != "/" else query_keys[:keys_len - 1]
        nested_obj_ = test_case[0]
        print(f"Nested Object: {nested_obj_} \nKeys: {query_keys}")
        value = get_nested_object_value(nested_obj_, query_keys)
        print(f"Value: {value}")


if __name__ == '__main__':
    main()

