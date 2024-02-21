# PowerQuery-CalenderTable

カレンダーテーブルを作成するPower Query のコードです。

# 使用方法 Usage

Power BI Desktop や DataflowなどのPower Query を扱える製品で、「空のクエリ」をクリック。

![image](https://github.com/hanaseleb/PowerQuery-CalenderTable/assets/8947320/d7a4a012-0389-49b0-ac83-6acf9a817072)

その後、詳細エディターをクリック。最初から入っているコードを削除して、本リポジトリのコードを貼り付けます。

https://github.com/hanaseleb/PowerQuery-CalenderTable/blob/main/CalenderTable.pq

![image](https://github.com/hanaseleb/PowerQuery-CalenderTable/assets/8947320/d22e3721-e052-4d24-821b-28f0822473d3)

変数を4つ入力をする。

- StartDate => カレンダーテーブルの最初の日付
- EndDate => カレンダーテーブルの最終日付
- FirstFiscalYear（option） => 会計年度が始まった年を入力
- StartFiscalMonth（option） => 会計年の初月を入力

FirstFiscalYearとStartFiscalMonthの入力をしない場合は会計年関係がすべてエラーになるので、コード自体からその列を削除するか、テーブルから列を削除してください。

![image](https://github.com/hanaseleb/PowerQuery-CalenderTable/assets/8947320/15c1f0c7-79df-472a-bd15-cfb396eae811)

最後、わかりやすいようにテーブル名を変えておきましょう。

ex) CalenderTable 

![image](https://github.com/hanaseleb/PowerQuery-CalenderTable/assets/8947320/6c49e7f9-0cdb-4e4a-8a9c-5c38e03a1116)

# Contribute 

issue、プルリク、大歓迎です～！
