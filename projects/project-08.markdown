---
layout: post
title: Project 8
due: "Oct 30, 11:59pm"
categories: [projects]
---

# Project 8

- Read pp. 121-130 and look at the program flow commands on p. 133.

- Create a repository on Bitbucket named exactly `csci201-project-08`. Invite me (`joshuaeckroth`) as a reader.

## Task

Using only these stack VM operations,

```
push pop add sub neg eq gt lt and or not label goto if-goto
```

rewrite the code below. Note, `push` comes in two forms: `push constant [num]` and `push static [num]`. The former pushes a constant value (e.g., 52) to the top of the stack, while the latter pushes a global ("static") variable (stored in `RAM[16]` and higher) to the stack. The `pop` operation should only be used as `pop static [num]`.

Assume the `push static` and `pop static` use the following variable translations:

```
a=0, b=1, c=2, d=3, e=4, ...
```

For example, if you see `c = ...` in the Java-like code below then that's a `pop static 2` because `c` is the same as `2` and `pop` is the same as "take off stack, save into variable". If you see `c` mentioned in a calculation, e.g., `c * 55`, you can push its value on the stack with `push static 2`. You can push the `55` with `push constant 55`.

Test in the `VMEmulator` using the test scripts in [this ZIP file](/code/project-08.zip).

Note: you must include these two lines at the end of every program (even "minimal" programs):

```
label end
goto end
```

### Program 1

{% highlight java %}
a = a + b
{% endhighlight %}

### Program 2

{% highlight java %}
x = -(a + b + c) * 2;
{% endhighlight %}

### Program 3

{% highlight java %}
if(x > 0) {
    y = 1;
} else {
    y = 2;
}
{% endhighlight %}

### Program 4

{% highlight java %}
// the final output we care about is j
// take note that k comes from the test script
int j = 0;
for(int i = 0; i < k; i++) {
    i = i + j;
    j++;
}
{% endhighlight %}

## Extra credit

+0.5pts for each minimal program.