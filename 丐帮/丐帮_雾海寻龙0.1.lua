

function Main()
    --/cast ��������
    --/cast ��Ȯ����
    --/cast [buff:��Ծ��Ԩ] �����л�
    --/cast ��ս��Ұ
    --/cast [buff:��ս��Ұ] ��Ծ��Ԩ
    --/cast ������
    --/cast ��������
    --/cast ��������

    cast("��������")
    cast("��Ȯ����")
    if buff("��Ծ��Ԩ") then
        cast("�����л�")
    end
    cast("��ս��Ұ")
    if buff("��ս��Ұ") then
        cast("��Ծ��Ԩ")
    end
	cast("������")
	cast("��������")
	cast("��������")
end