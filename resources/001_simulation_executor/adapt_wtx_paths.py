import glob
import os
import sys

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

def get_fea_file_paths(fea_dir):
    """
    Get the list of file paths in the specified FEA directory.

    :param fea_dir: Path to the FEA directory.
    :return: List of FEA file paths.
    """
    return glob.glob(os.path.join(fea_dir, '*'))

def get_search_fea_file_paths(fea_file_paths):
    """
    Create search patterns for the FEA file paths.

    :param fea_file_paths: List of FEA file paths.
    :return: List of search patterns for the FEA file paths.
    """
    return ['\\'.join(fea_file_path.split('/')[-2:]) for fea_file_path in fea_file_paths]

def process_wtx_file(wtx_file_path, search_fea_file_paths):
    """
    Process the WTX file, replacing text between angle brackets.

    :param wtx_file_path: Path to the WTX file.
    :param search_fea_file_paths: List of search patterns for FEA file paths.
    :return: List of processed lines from the WTX file.
    """
    new_wtx_file_lines = []
    with open(wtx_file_path, 'r') as wtx_file:
        for line in wtx_file:
            for fea_file_path in search_fea_file_paths:
                if fea_file_path in line:
                    line = replace_between_angle_brackets(line, '..\\' + fea_file_path)
            new_wtx_file_lines.append(line)
    return new_wtx_file_lines

def main():
    wtx_file_path = sys.argv[1]
    fea_dir = sys.argv[2]

    fea_file_paths = get_fea_file_paths(fea_dir)
    search_fea_file_paths = get_search_fea_file_paths(fea_file_paths)

    new_wtx_file_lines = process_wtx_file(wtx_file_path, search_fea_file_paths)
    write_lines_to_file(new_wtx_file_lines, wtx_file_path)

if __name__ == '__main__':
    main()
