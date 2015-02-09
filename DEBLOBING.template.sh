ls -l `cygpath $WORKSPACE`

[ -d "/cygdrive/a/src" ] || mkdir /cygdrive/a/src

# Распаковать исходные тексты
for i in `cygpath $WORKSPACE`/*tre.tar.gz ; do
     [ -e $i ] && tar xfz $i -C /cygdrive/a/src
done

# Удалить объединённые tre-файлы
for i in `cygpath $WORKSPACE`/*_all.tre ; do
    [ -e $i ] && rm -f $i
done

# Удалить tre-файлы с нулевой длиной
for tre_file  in `cygpath $WORKSPACE`/*.tre; do
    [ ! -s $tre_file  ] && rm -f $tre_file 
done

# Поочерёдно обработать все tre-файлы 
for tre_file in `cygpath $WORKSPACE`/*.tre ; do
    cp $tre_file $tre_file.old
    # Преобразовать пути в tre-файлах из unix-вида в windows-вид 
    cat $tre_file.old | tr '\/' '\\' | sed 's/^/a\:\\src/' > $tre_file
    rm $tre_file.old

    echo "File;Line;Average;Max peak;Description;" > $tre_file.csv
    # вывести найденное содержимое в файл таблицы CSV
    `cygpath $WORKSPACE/$JOB_NAME`/BlobSearch.exe `cygpath -w $tre_file` 4 30 >> $tre_file.csv
    wc -l  $tre_file.csv
done

# Проверить файлы CSV по базе раннее описанных блобов.
for csv_file in `cygpath $WORKSPACE`/*.csv ; do
    echo "Check described BLOBs."
    $WORKSPACE/$JOB_NAME/blob_helper.sh $WORKSPACE/$JOB_NAME/blobs1.db $csv_file 
done

# Удалить исходные тексты
rm -rf /cygdrive/a/src