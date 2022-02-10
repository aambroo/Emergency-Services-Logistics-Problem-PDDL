# Problem1
First we modelled a domain where we specified what the content of each crate was. Later on with the development we decided to make the content dynamic, in the sense that the we attribute each crate a variable representing its content, and only later in the problem file we defined its actual content.
Although this solution appeared to solve our initial problems in the first place, it still involved redundant calling of variables.
After delving deeper into the `planutils` documentation, it turned out to be easier to treat each crate's content as an object, and 'call it back' only in the problem file.
