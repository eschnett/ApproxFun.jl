using ApproxFun



##Airy equation 


d=Interval(-10.,5.);
Bm=EvaluationFunctional(d,d.a);
Bp=EvaluationFunctional(d,d.b);
B=[Bm,Bp];
D2=diff(d,2);
X=MultiplicationOperator(Fun(x->x,d));

u=[B,D2-X]\[airyai(d.a),airyai(d.b),0.];

@assert abs(u[0.]-airyai(0.)) < 1000eps()



d=Interval(-1000.,5.);
Bm=EvaluationFunctional(d,d.a);
Bp=EvaluationFunctional(d,d.b);
B=[Bm,Bp];
D2=diff(d,2);
X=MultiplicationOperator(Fun(x->x,d));

u=[B,D2-X]\[airyai(d.a),airyai(d.b),0.];
@assert abs(u[0.]-airyai(0.))/length(u)<100eps()



B=neumann(d);
A=[B;D2-X];                
b=[airyaiprime(d.a),airyaiprime(d.b),0.];   
    
u=A\b;                     

@assert abs(u[0.]-airyai(0.)) < 1000eps()

## Neumann condition



f=Fun(x->x.^2)
D=diff(f.domain)
@assert norm(D*f - diff(f)) < 100eps()


##Test versus exp

f=Fun(x->-x.^2)
g=Fun(t->exp(-t.^2))

@assert norm(Fun(t->exp(f[t]))-g)<10eps()

fp=diff(f);
Bm=EvaluationFunctional(f.domain,f.domain.a);
u=[Bm,diff(f.domain) - fp]\[exp(f[f.domain.a]),0.];
@assert norm(u-g)<10eps()



## Oscillatory integral

f=Fun(exp);
D=diff(f.domain);
w=10.;
B=BasisFunctional(floor(w));
A=[B,D+1im*w*I];
u = A\[0.,f];
@assert abs(u[1.]exp(1im*w)-u[-1.]exp(-1im*w)-(-0.18575766879136255 + 0.17863980562549928im ))<eps()



## Bessel

d=Interval()
D=diff(d)
x=Fun(identity,d)
A=x.^2*D^2+x*D+x.^2;
u=[dirichlet(d)[1],A]\[besselj(0,d.a),0.];
@assert abs(u[0.1]-besselj(0.,0.1))<10eps()



## Matrix exponential

n=4
d=fill(Interval(0.,1.),n)
B=EvaluationFunctional(d,0.)
D=DerivativeOperator(d)
A=rand(n,n)
L=[B;D-A]
u=L\eye(n)
@assert norm(evaluate(u,1.)-expm(A))<100eps()



## Null space

d=Interval(-50.,5.)
D=diff(d)
x=Fun(identity,d)
u=null(D^2-x)
c=[evaluate(u,d.a)'; evaluate(u,d.b)']\[airyai(d.a),airyai(d.b)]
@assert norm(dot(c,u)-Fun(airyai,d))<eps()