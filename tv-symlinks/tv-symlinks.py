import argparse
import os
import sys
from pathlib import Path
import itertools
from fnmatch import fnmatch
import logging

logging.basicConfig(level=logging.INFO, stream=sys.stdout)


def main(args):
    def match(file: Path, masks: list[str] = None) -> bool:
        if file.is_dir():
            return False

        if masks is None:
            masks = []

        return all([not fnmatch(file.name, mask) for mask in masks])

    src = Path(args.input)
    skip_masks = list(itertools.chain.from_iterable([x.split(',') for x in args.skip]))
    files = list(filter(lambda x: match(x, skip_masks), src.iterdir()))
    files.sort()

    dst = Path(args.output)
    dst.mkdir(parents=True, exist_ok=True)
    for idx, file in enumerate(files, start=args.start_num):
        p = dst / f'{args.name} - S{args.season:02d}E{idx:02d}{file.suffix}'
        logging.info(f'Linking {file} to {p}')
        try:
            p.symlink_to(file, False)
        except FileExistsError:
            logging.warning('File already linked')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Produces symlinks of files in source directory in target directory,'
                                                 'using SxxEyy naming convention on files sorted lexicographically')
    parser.add_argument('-I', '--input', metavar='source_dir', type=str, required=True, help='Source directory')
    parser.add_argument('-O', '--output', metavar='destination_dir', type=str, required=False, default=os.getcwd(),
                        help='Destination directory. Default to current directory.')
    parser.add_argument('-n', '--name', metavar='show_name', type=str, required=True,
                        help='Show name. Used for naming symlinks')
    parser.add_argument('-s', '--season', metavar='season_number', type=int, required=False, default=1,
                        help='Season number. Used for naming symlinks. Defaults to 1 and results in S01Exx names.')
    parser.add_argument('-S', '--start-num', metavar='start_number', type=int, required=False, default=1,
                        help='First episode number. Used for naming symlinks. Default to 1 and results in SxxE01 names')
    parser.add_argument('--skip', metavar='skip_files', action='store', nargs='*', default=['*.nfo', '*.zip', '*.srt'],
                        help='Mask for files that should be skipped. Supply multiple masks by splitting them with comma'
                             'or providing multiple --skip arguments.')
    args = parser.parse_args()
    main(args)
