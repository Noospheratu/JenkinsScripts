ls -l `cygpath $WORKSPACE`

[ -d "/cygdrive/a/src" ] || mkdir /cygdrive/a/src

# ����������� �������� ������
for i in `cygpath $WORKSPACE`/*tre.tar.gz ; do
     [ -e $i ] && tar xfz $i -C /cygdrive/a/src
done

# ������� ����������� tre-�����
for i in `cygpath $WORKSPACE`/*_all.tre ; do
    [ -e $i ] && rm -f $i
done

# ������� tre-����� � ������� ������
for tre_file  in `cygpath $WORKSPACE`/*.tre; do
    [ ! -s $tre_file  ] && rm -f $tre_file 
done

# ��������� ���������� ��� tre-����� 
for tre_file in `cygpath $WORKSPACE`/*.tre ; do
    cp $tre_file $tre_file.old
    # ������������� ���� � tre-������ �� unix-���� � windows-��� 
    cat $tre_file.old | tr '\/' '\\' | sed 's/^/a\:\\src/' > $tre_file
    rm $tre_file.old

    echo "File;Line;Average;Max peak;Description;" > $tre_file.csv
    # ������� ��������� ���������� � ���� ������� CSV
    `cygpath $WORKSPACE/$JOB_NAME`/BlobSearch.exe `cygpath -w $tre_file` 4 30 >> $tre_file.csv
    wc -l  $tre_file.csv
done

# ��������� ����� CSV �� ���� ������ ��������� ������.
for csv_file in `cygpath $WORKSPACE`/*.csv ; do
    echo "Check described BLOBs."
    $WORKSPACE/$JOB_NAME/blob_helper.sh $WORKSPACE/$JOB_NAME/blobs1.db $csv_file 
done

# ������� �������� ������
rm -rf /cygdrive/a/src