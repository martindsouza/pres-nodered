


# Remind People

**THINK DIFFERENT!**


# Problem: Introduction to NodeRed

## Solution: 

```bash
ssh opc@ocidockerdev.talkapex.com

docker run -it -d \
  -p 1880:1880 \
  -v node-red:/data \
  --name nodered \
  --network=oracle_network \
  martindsouza/node-red-oracle

# Talk about port forwarding with Tunnel
```

## Backup of flows:

```bash
sudo -i

cd /var/lib/docker/volumes/node-red/_data/
yes | cp -rf /var/lib/docker/volumes/node-red/_data/flows.json /var/lib/docker/volumes/node-red/_data/flows.bkp

```


# Oracle Setup 

Server: `oracle-xe`
Database: `oracle-xe`
Port: `1521`

- Go to: http://localhost:9980
- Show Nodes on left
- Show basic Timer > Debug > Output
  - Good for testing



# Problem: Create Web Service

Want to create a quick web service to say "hello world"

## Solution:

- Node: http
  - GET: `/hello`
- Node: Template:
  - `Hello OOW`
- Node: http response
- http://localhost:9980/hello


### Advanced: Pass in my name

- Node: http
  - Get: `/hello/:name`
- Add Node: Debug
  - Set to all `msg` 
- http://localhost:9980/hello/martin
  - Look at debug and look at `req/params`
- Add Node: Change
  - Set `msg.payload`
  - to: `msg.req.params`
- Modify Node: Template
  - `Hello OOW {{payload.name}}`
- http://localhost:9980/hello/martin


**Note: We'll come back to more of this terminology soon**


# Problem: Generate CSV of a query

Want to generate a CSV file of a query via a URL

_Note: Can do in ORDS as well, but think about who's doing it._

## Solution:


** Step 1: ** Setup the query

- Node: Timestamp
- Node: Oracle
  - Query: `select * from emp`
  - Field Mappinhs: `null`
  - Results: `Single result message`
- Node: Debug


Demo


** Step 2: ** Add CSV

- Node: CSV
  - Columns: `EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO`
  - Output: `Include Column Name Row`


Demo


** Step 3: ** Add HTTP

- Node: http
  - Prefix at start
  - URL: `/demo-csv`
- Node: HTTP Response
  - Suffix at end
  - Headers
    - `Content Type`: `text/csv`
    - `content-disposition` : `attachment; filename="emp.csv"`
- Demo: http://localhost:9980/demo-csv


# Problem: Track file changes

This can happen when people to bulk dumps of files on a file system

```sql

truncate table big_mac_index;

select count(1)
from big_mac_index;
```


## Solution:

```bash
sudo -i
cd /var/lib/docker/volumes/node-red/_data/oowdemo
# mkdir oowdemo

# Note: this maps to: /data/oowdemo in container

# Src: https://github.com/TheEconomist/big-mac-data/tree/master/output-data
cd /tmp
wget -O bmi.csv https://raw.githubusercontent.com/TheEconomist/big-mac-data/master/output-data/big-mac-adjusted-index.csv

cd /var/lib/docker/volumes/node-red/_data/oowdemo
cp /tmp/bmi.csv .

```

**Step1: ** Just read the file

- Node: Timestamp
- Node: Read file: `/data/oowdemo/bmi.csv`

**Step 2: ** Convert to CSV and insert into DB

- Node: CSV
  - Columns: `date,iso_a3,currency_code,name,local_price,dollar_ex,dollar_price,GDP_dollar,adj_price,USD,EUR,GBP,JPY,CNY`
  - First row contains header: Check
- Node: Oracle
  - Field Mappings: `["date","iso_a3","currency_code","name","local_price","dollar_ex","dollar_price","GDP_dollar","adj_price","USD","EUR","GBP","JPY","CNY"]`
  - Results: `Ignore Results`
  - SQL: 

```sql
insert into big_mac_index(
  bmi_date,
  iso_a3,
  currency_code,
  name,
  local_price,
  dollar_ex,
  dollar_price,
  gdp_dollar,
  adj_price,
  usd,
  eur,
  gbp,
  jpy,
  cny
)
values(
  to_date(:valueOfValuesArrayIndex0, 'YYYY-MM-DD'),
  :valueOfValuesArrayIndex1,
  :valueOfValuesArrayIndex2,
  :valueOfValuesArrayIndex3,
  :valueOfValuesArrayIndex4,
  :valueOfValuesArrayIndex5,
  :valueOfValuesArrayIndex6,
  :valueOfValuesArrayIndex7,
  :valueOfValuesArrayIndex8,
  :valueOfValuesArrayIndex9,
  :valueOfValuesArrayIndex10,
  :valueOfValuesArrayIndex11,
  :valueOfValuesArrayIndex12,
  :valueOfValuesArrayIndex13
)
```

** Step 3: ** Solve 500 Solution

- Node CSV: Change to one array message
- Node: Split: `20`
- Node: JSON: 
- Node: Change
  - `move` : `msg.payload`
    - `msg.payload.data`
- Node: Oracle
  - Field Mappings: `[ "data" ]`


```sql
insert into big_mac_index(
  bmi_date,
  iso_a3,
  currency_code,
  name,
  local_price,
  dollar_ex,
  dollar_price,
  gdp_dollar,
  adj_price,
  usd,
  eur,
  gbp,
  jpy,
  cny
)
select 
  to_date(bmi_date, 'YYYY-MM-DD') bmi_date,
  iso_a3,
  currency_code,
  name,
  local_price,
  dollar_ex,
  dollar_price,
  gdp_dollar,
  adj_price,
  usd,
  eur,
  gbp,
  jpy,
  cny
from json_table(:valueOfValuesArrayIndex0, '$[*]'
  columns(
    bmi_date varchar2(255) path '$.date',
    iso_a3 varchar2(255) path '$.iso_a3',
    currency_code varchar2(255) path '$.currency_code',
    name varchar2(255) path '$.name',
    local_price number path '$.local_price',
    dollar_ex number path '$.dollar_ex',
    dollar_price number path '$.dollar_price',
    gdp_dollar number path '$.GDP_dollar',
    adj_price number path '$.adj_price',
    usd number path '$.USD',
    eur number path '$.EUR',
    gbp number path '$.GBP',
    jpy number path '$.JPY',
    cny number path '$.CNY'
  )
)
```


TODO show 


** Step 4: ** Drop file


```bash
# Clear the test data
rm -rf /data/oowdemo/bmi.csv
```

- Node: Watch: `/data/oowdemo/`
- Node: File (modify)
  - Filename: `<blank>`
- Disconnect Oracle and debug JSON to test:


```bash
# sudo -i 

cp /tmp/bmi.csv /var/lib/docker/volumes/node-red/_data/oowdemo
```


- Truncate Table
- Reconnect Oracle
`cp /tmp/bmi.csv /var/lib/docker/volumes/node-red/_data/oowdemo`



**Step 5: HTTP Request **

- Node: Watch - Disconnect
- Node: Http Request
  - Attach to Timeer
  - GET: `https://raw.githubusercontent.com/TheEconomist/big-mac-data/master/output-data/big-mac-adjusted-index.csv`
  - Attach to CSV

- Truncate Table





# Problem: Customize Functions

Want to add a bit of programming to massage the data.

Using same data as before want to only get date and lower currency code.

## Solution

- Node: Timer
- Node: http request
  - GET: `https://raw.githubusercontent.com/TheEconomist/big-mac-data/master/output-data/big-mac-adjusted-index.csv
- Node: CSV
- Node: Function
  
```javascript
let tmp = {};

tmp.date = msg.payload.date
tmp.curcode = msg.payload.currency_code.toLowerCase();

msg.payload = tmp;

return msg;
```



# Problem:

Want to read emails


## Solution


** Step 1: ** 

- Node: Email
  - Getmail Every: `5`
  - Userid: `03j.dsouza@gmail.com`
  - pass: ENPASS
- Node: Debug
  - All Message object


** Step 2: ** Parse message

- Node: Function

```js
let tmp = {};

tmp.msg = msg.payload;
tmp.subject = msg.topic;
tmp.from = msg.header.from.value[0].address;

msg.payload = tmp;

return msg;

```

- Node: Debug
  - Just set to `msg.payload`



** Step 3: ** Insert to table

- Node Oracle
  - Field Mappings: ["msg","subject","from"]
  - Results: Ignore
  - Query: 

```sql
insert into email (
  msg, 
  subject, 
  from_address
)
values (
  :valueOfValuesArrayIndex0, 
  :valueOfValuesArrayIndex1, 
  :valueOfValuesArrayIndex2
)
```



** Step 4: ** JSON Processing

_Suppose the email was a JSON data and you wanted to process it_


- Node: Oracle: Disconnect
- Node: JSON
  - `payload.msg`
  - Connect to Debug (should be 2 debugs now)

Demo: 

```json
{
  "name" : "martin",
  "email" : "mdsouza@insum.ca"
}
```
  - Show the String vs JSON data

Next:

- Node: Template
  
```
Hello {{payload.msg.name}}.

You sent this from {{payload.msg.email}}
```

- Node Debug
  - Only connect template
  - Set to `msg.payload`


Demo: Send same email



# Problem: import / export

How do I "share" or save these individuall?

## Solution:

Simple JSON architecture

- Menu > Export > Clipboard 
  - Chose Formatted

Should look like: demo-export.json


** Step 2: ** Import:

- Menu > Import > Clipboard (could be a file)
- 





