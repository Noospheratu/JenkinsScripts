ls -l `cygpath $WORKSPACE`

# �������� ������� ��� ������� 
[ -d "$WORKSPACE/reports" ] && rm -rf $WORKSPACE/reports
mkdir -p $WORKSPACE/reports

# �������� ������� ��� �������� �������
[ -d "/cygdrive/a/src" ] && rm -rf /cygdrive/a/src
mkdir -p /cygdrive/a/src

# ����������� ���������
# TODO: �������� � �������� � ������������ - ����� ������� � �����������,
# ����������� �� tre-������, ����� ����� ����� *tre.tar.gz
for i in `cygpath $WORKSPACE`/*tre.tar.gz; do
    tar xfz $i -C /cygdrive/a/src
done

# ������� tre-����� � ������� ������
for tre_file  in `cygpath $WORKSPACE`/*.tre; do
    [ ! -s $tre_file  ] && rm -f $tre_file 
done

# ������������� ���� � tre-������ � windows-�������������
for tre_file in `cygpath $WORKSPACE`/*.tre ; do
    cp $tre_file $tre_file.old
    cat $tre_file.old | tr '\/' '\\' | sed 's/^/a\:\\src/' > $tre_file
    rm $tre_file.old
done


echo "Run ak-vs"
cd /cygdrive/c/Program\ Files\ \(x86\)/Echelon/AK-VS/

for tre_file in `cygpath $WORKSPACE`/*.tre ; do

  echo $tre_file

  name=`basename $tre_file`
  project_name="${name%.tre}"
  # TODO: ������� ��������� ��������� ������ �� ��������� ����������, ����������
  # �������� ����������� ����������. 
  ./ak-vs.exe --ru -p $project_name -m 3 -s !chxProbes -s chxSignatures -s chxGraphs -s chxSchemes -e -f `cygpath -w $tre_file` -o  `cygpath -w $WORKSPACE/reports` -l `cygpath -w $WORKSPACE/logs/$project_name` --quiet_mode -r

  tar cfz $WORKSPACE/$project_name.akvs.tar.gz `cygpath $WORKSPACE`/reports 

done


rm -rf /cygdrive/a/src
