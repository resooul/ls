
javaclasspath('CEC08 Func\FractalFunctions.jar');
addpath(genpath(pwd));

global initial_flag

%d: dimensionality
d = 1000;
%maxfe: maximal number of fitness evaluations
maxfe = d*5000;
%runnum: the number of trial runs
runnum = 30;

results = zeros(7,runnum);
 
for funcid = 1 : 7
    n = d;
    initial_flag = 0;
    
    switch funcid
         case 1

            % lu: define the upper and lower bounds of the variables
            lu = [-100 * ones(1, n); 100 * ones(1, n)];

        case 2

            lu = [-100 * ones(1, n); 100 * ones(1, n)];


        case 3

            lu = [-100 * ones(1, n); 100 * ones(1, n)];


        case 4

            lu = [-5 * ones(1, n); 5 * ones(1, n)];


        case 5

            lu = [-600* ones(1, n); 600 * ones(1, n)];



        case 6

            lu = [-32 * ones(1, n); 32 * ones(1, n)];


        case 7

            lu = [-1 * ones(1, n); 1 * ones(1, n)];


    end

    % population size setting
    if(d >= 5000)
        m = 1500;
    elseif(d >= 2000)
        m = 1000;
    elseif(d >= 1000)
        m = 500;
    elseif(d >= 100)
        m = 100;
    end;

% several runs
for run = 1 : runnum

    % initialization
    XRRmin = repmat(lu(1, :), m, 1);
    XRRmax = repmat(lu(2, :), m, 1);
    %rand('seed', sum(100 * clock));
    rand('seed', 123456);
    pop = XRRmin + (XRRmax - XRRmin) .* rand(m, d);
    historical_pop=XRRmin + (XRRmax - XRRmin) .* rand(m, d);
    fitness = benchmark_func(pop, funcid);
    v = zeros(m,d);
    bestever = 1e200;
    DIM_RATE = 1;
    
    FES = m;
    gen = 0;
    
    tic;
    % main loop
    while(FES < maxfe)

        %SELECTION-I
        if rand<rand, historical_pop=pop; end  % see Eq.3 in [1]
        historical_pop=historical_pop(randperm(m),:); % see Eq.4 in [1]
        
        F=3*randn;
        
        map=zeros(m,d); % see Algorithm-2 in [1]         
        if rand<rand,
            for i=1:m,  u=randperm(d); map(i,u(1:ceil(DIM_RATE*rand*d)))=1; end
        else
            for i=1:m,  map(i,randi(d))=1; end
        end
        
        % RECOMBINATION (MUTATION+CROSSOVER)   
        offsprings=pop+(map.*F).*(historical_pop-pop);   % see Eq.5 in [1]    
        offsprings=bsa_boundaryControl(offsprings,XRRmin,XRRmax); % see Algorithm-3 in [1]
        
        % fitness evaluation
        fitness = benchmark_func(offsprings, funcid);
        bestever = min(bestever, min(fitness));
        FES = FES + ceil(m/2);
        fprintf('Best fitness: %e FES %d\n', bestever,FES); 

        gen = gen + 1;
    end;
    
    results(funcid, runnum) = bestever;
    fprintf('Run No.%d Done!\n', run); 
    dispopulation(['CPU time: ',num2str(toc)]);
end;
 save resultsBSA.mat results
end;


    

