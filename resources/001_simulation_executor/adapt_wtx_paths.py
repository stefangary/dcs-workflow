import os
import sys

wtx_file_path = sys.argv[1]
fea_dir = sys.argv[2].replace('/','')

def replace_between_angle_brackets(input_string, replacement):
    """
    Replaces anything between '>' and '<' in the given string with the specified replacement text.

    :param input_string: The input string containing text to be replaced.
    :param replacement: The text to replace the content between '>' and '<'.
    :return: A new string with the replacements made.
    """
    left = input_string.split('>')[0]
    right = input_string.split('<')[-1]
    return left + '>' + replacement + '<' + right

def write_lines_to_file(lines, file_path):
    """
    Writes each line in the provided list to the specified file.

    :param lines: List of lines to write to the file
    :param file_path: Path to the file where the lines will be written
    """
    with open(file_path, 'w') as file:
        file.writelines(lines)

def get_search_file_paths(file_paths):
    """
    Create search patterns for the file paths.

    :param file_paths: List of file paths.
    :return: List of search patterns for the file paths.
    """
    #return ['\\'.join(file_path.split('/')) for file_path in file_paths]
    return [os.path.basename(file_path) for file_path in file_paths]

def process_wtx_file(wtx_file_path, search_file_paths):
    """
    Process the WTX file, replacing text between angle brackets.

    :param wtx_file_path: Path to the WTX file.
    :param search_file_paths: List of search patterns for file paths.
    :return: List of processed lines from the WTX file.
    """
    new_wtx_file_lines = []
    with open(wtx_file_path, 'r') as wtx_file:
        for line in wtx_file:
            for file_path in search_file_paths:
                if file_path in line:
                    line = replace_between_angle_brackets(line, '..\\' + fea_dir + '\\' + file_path)
            new_wtx_file_lines.append(line)
    return new_wtx_file_lines

def find_all_files_os():
    files = []
    for root, _, filenames in os.walk('.'):
        for filename in filenames:
            file_path = os.path.join(root, filename)
            if file_path.startswith('./'):
                file_path = file_path[2:]
            files.append(file_path)
    return files

def main():
    wtx_file_path = sys.argv[1]

    file_paths = find_all_files_os()
    search_file_paths = get_search_file_paths(file_paths)

    new_wtx_file_lines = process_wtx_file(wtx_file_path, search_file_paths)
    write_lines_to_file(new_wtx_file_lines, wtx_file_path)

if __name__ == '__main__':
    main()
