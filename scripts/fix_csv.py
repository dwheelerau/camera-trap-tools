import csv
import sys

outfile = sys.argv[1].replace('.csv','fixed.csv')
outfile_h = open(outfile, 'w')
csv_writer = csv.writer(outfile_h)

with open(sys.argv[1]) as rf:
    csv_reader = csv.reader(rf)
    header = next(csv_reader)
    for row in csv_reader:
        fname = row[0].split('/')[-1]
        conf = float(row[1])
        if conf >= 0.8:
            res = 'TP'
        else:
            res = 'TN'
        row[0] = fname
        row.insert(2, res)
        csv_writer.writerow(row)
outfile_h.close()
