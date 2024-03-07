from flask import Flask, render_template, request, redirect, url_for, flash
import flask
# import fileutils
import pymysql
from datetime import datetime


# 连接数据库
myconn = pymysql.connect(host='127.0.0.1', port=3306, user='wei', passwd='12qw', db='mydbsql', charset='utf8')
mycursor = myconn.cursor()
# print("test connect:",myconn)

app = Flask(__name__)
app.secret_key = '12qwaszx'
# 引入file_dict用户列表

# 存储登陆用户的名字用户其它网页的显示
users = []
@app.route('/')
def index():
    return render_template('login.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    # 增加会话保护机制(未登录前login的session值为空)
    flask.session['login'] = ''
    if request.method == 'POST':
        user = request.form.get("username", "")
        pwd = request.form.get("password", "")
    else:
        user = ''
        pwd = ''
    print('username:%s,password:%s' % (user, pwd))

    # 查询管理员数据库中是否存在该管理员
    sql = "SELECT * FROM admin WHERE username=%s AND password=%s"
    mycursor.execute(sql, (user, pwd))
    result = mycursor.fetchone()

    if result:
        # 登录成功
        flask.session['login'] = 'OK'
        users.append(user)  # 存储登录成功的用户名用于显示
        return redirect(url_for('home'))
    else:
        msg = '用户名或密码错误'
        return render_template('login.html', msg=msg)

@app.route('/home')
def home():
    if flask.session.get("login", "") == '':
        # 用户没有登录
        return redirect(url_for('login'))
    # 当用户登录有存储信息时显示用户名，否则为空
    user_info = users[0] if users else ''
    return render_template('home.html', user_info=user_info, content='')

# 负责显示零钱投资的表格
@app.route('/petty_cash')
def petty_cash():
    if flask.session.get("login", "") == '':
        # 用户没有登录
        return flask.redirect(url_for('login'))
    mycursor.execute("SELECT * FROM change_money")
    results = mycursor.fetchall()

    # 格式化查询结果为适合在模板中使用的形式
    products = []
    for row in results:
        product = {
            "id": row[0],
            "name": row[1],
            "daily_interest": row[2],
            "daily_income_per_10k": row[3],
            "invesMoney":row[4]
        }
        products.append(product)
    # content = '这是零钱理财页面的内容。'
    return flask.render_template('petty_cash.html', user_info='', products=products)

@app.route('/investment/<int:product_id>', methods=['GET', 'POST'])
def investment(product_id):
    # 如果是POST请求，表示用户提交了表单
    if request.method == 'POST':
        # 从表单中获取用户提交的投资金额
        inves_money = request.form['inves_money']

        # 更新数据库中对应产品的投资金额
        sql = "UPDATE change_money SET invesMoney = %s WHERE id = %s"
        mycursor.execute(sql, (inves_money, product_id))
        myconn.commit()

        #更新资金记录的表单
        # 查询投资产品的名称作为来源
        sql = "SELECT name FROM change_money WHERE id = %s"
        mycursor.execute(sql, (product_id,))
        product_name = mycursor.fetchone()[0]

        # 将资金使用情况写入flow_of_funds表单
        source = product_name  # 来源为投资产品的名称
        flowMoney = inves_money
        sql = "INSERT INTO flow_of_funds (createTime, source, flowMoney) VALUES (%s, %s, %s)"
        mycursor.execute(sql, (datetime.now(), source, flowMoney))
        myconn.commit()

        # 提交成功后重定向到零钱理财页面
        return redirect(url_for('petty_cash'))
    # 如果是GET请求，渲染投资页面，并传递产品id用于显示相应的产品信息
    sql = "SELECT * FROM change_money WHERE id = %s"
    mycursor.execute(sql, (product_id,))
    product = mycursor.fetchone()
    return render_template('investment.html', product=product)

@app.route('/invest_page')
def invest_page():
    return render_template('investment.html')

@app.route('/add_record', methods=['GET', 'POST'])
def add_record():
    if request.method == 'POST':
        # 从表单中获取用户输入的新增条目信息
        product_name = request.form['product_name']
        daily_interest = request.form['daily_interest']
        daily_income_per_10k = request.form['daily_income_per_10k']
        inves_money = request.form['inves_money']

        # 将新增条目信息写入数据库
        sql = "INSERT INTO change_money (name, annualIncome, peiIncome, invesMoney) VALUES (%s, %s, %s, %s)"
        mycursor.execute(sql, (product_name, daily_interest, daily_income_per_10k, inves_money))
        myconn.commit()

        # 提交成功后重定向到零钱理财页面
        return redirect(url_for('petty_cash'))

    return render_template('add_record.html')

@app.route('/apply_loan', methods=['GET', 'POST'])
def apply_loan():
    if request.method == 'POST':
        # 获取表单提交的借贷金额和借贷期限
        loan_amount = request.form['loan_amount']
        loan_term = request.form['loan_term']

        # 将用户输入的信息写入 flow_of_funds 表
        sql = "INSERT INTO flow_of_funds (createTime, source, flowMoney) VALUES (NOW(), '网贷', %s)"
        mycursor.execute(sql, (loan_amount,))
        myconn.commit()

        return redirect(url_for('home'))  # 返回主页面

    # GET 请求时查询贷款期限和最新的贷款利率
    mycursor.execute("SELECT rate FROM loan LIMIT 1")
    annual_interest_rate = mycursor.fetchone()[0]

    return render_template('apply_loan.html', loan_terms=['1年', '2年', '3年', '4年', '5年'],
                           annual_interest_rate=annual_interest_rate)


@app.route('/funds_records', methods=['GET', 'POST'])
def funds_records():
    # 查询 flow_of_funds 表中的数据
    mycursor.execute("SELECT createTime, source, flowMoney FROM flow_of_funds ORDER BY createTime DESC")
    records = mycursor.fetchall()
    print(records)
    return render_template('funds_records.html', records=records)


@app.route('/personal_center')
def personal_center():

    mycursor.execute(
        "SELECT username, realname, password, IDcard, phone, email, paypwd, reputation FROM user WHERE username = %s",
        (users[0],))
    user_info = mycursor.fetchone()
    print(user_info)
    print((user_info[0]))
    print((user_info[0]))
    print((user_info[0]))
    print((user_info[0]))
    # Pass the user information to the template
    return render_template('personal_center.html', user_info=user_info)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # 检查用户名是否已经存在
        mycursor.execute("SELECT * FROM user WHERE username = %s", (username,))
        existing_user = mycursor.fetchone()

        if existing_user:
            flash("User already exists!", "error")
            return render_template('register.html')
        else:
            # 将新用户插入数据库
            mycursor.execute("INSERT INTO user (username, password) VALUES (%s, %s)", (username, password))
            myconn.commit()
            flash("Registration successful! Please login.", "success")
            return redirect(url_for('login'))

    return render_template('register.html')

if __name__ == "__main__":
    # app.run(host='0.0.0.0', debug=True)
    app.run()