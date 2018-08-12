
numbins = 40;

mu1 = 35;
var1 = 2;
mu2 = 35;
var2 = 2;

zomegavals = [0.1:0.005:0.9];
omegavals = [0:0.01:1];
omegavals2 = [0.2:0.01:0.8]; % These will be used in the 3-D plot

ns = [0:numbins]';
card1 = binopdf( [0:numbins], mu1, 0.98 )';
card2 = binopdf( [0:numbins], mu2, 0.975 )';
%card1 = poisspdf( [0:numbins], mu1 +0.25 )';
% card2 = poisspdf( [0:numbins], mu2 + 0.1 )';
%card1 = nbinpdf( [0:numbins], mu1 +0.25 )';
%card2 = nbinpdf( [0:numbins], mu2 +0.1 )';
%card1 = [card1(1:mu1+1); flipud(card1(1:mu1))];

%card2 = [card2(1:mu2+1); flipud(card2(1:mu2))];


card1 = card1(1:length(ns));
card1 = card1/sum(card1);

card2 = card2(1:length(ns));
card2 = card2/sum(card2);


minseries = min( card1, card2 );

mymap = linspecer;
numcol = size( mymap, 1 );
numexp = length( zomegavals );

mymap2 = linspecer( length(ns) );
numcol2 = size( mymap2, 1 );


% 0) Plot the cardinalities
fhandle = figure
set( fhandle, 'Color', [1 1 1])
hold on
grid on
plot( ns, card1, 'b', 'linewidth', 2 )
plot( ns, card2, 'g', 'linewidth', 2 )  
axis([0 max(ns) 0 1])
set( gca, 'XtickMode', 'auto' )
set( gca, 'FontSize', 16 )
xlabel('n')
legend('p_i','p_j')


% 1) Fusion examples in separate figures
%
plotomegas3 = [0.3 0.4 0.5 0.6 0.7 0.8];
plotexamples = [1:numexp];

for j=1:length( plotomegas3)
    omegaval = plotomegas3( j );
    figure
    set(gcf, 'Color', [1 1 1])
    hold on
    grid on
    for i=1:length( plotexamples)
        zomega = zomegavals(plotexamples(i));
        zomegan = ( zomega.^ns );
        
        colnum = ceil(numcol*plotexamples(i)/numexp);
        col = mymap( colnum ,:);
        
        fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*zomegan;
        Nomega = sum(fusedcard);
        fusedcard =  fusedcard/Nomega;
        
        hold on
        plot( ns, fusedcard, 'Color', col,'Linewidth',1.5 )
    end
    colormap( mymap );
    cbh = colorbar( 'peer', gca );
    set( cbh, 'Ticks', [zomegavals(1) zomegavals(fix(numexp/6)) zomegavals(fix(3*numexp/6)) zomegavals(fix(5*numexp/6)) zomegavals(end)],...
        'TickLabels', {num2str( zomegavals(1) ), num2str( zomegavals(fix(numexp/6)) ), num2str( zomegavals(fix(3*numexp/6)) ) , num2str( zomegavals(fix(5*numexp/6)) ),num2str( zomegavals(end) ) } );
    
    axis([0 max(ns) 0 1])
    set( gca, 'XtickMode', 'auto' )
    set( gca, 'FontSize', 16 )
    xlabel('n')
    ylabel('p_\omega')
    title([['\omega'],sprintf('= %1.1f',omegaval)])
end



fig1 = figure;
set(fig1, 'Color', [1 1 1])
hold on
grid on



fig2 = figure;
set(fig2, 'Color', [1 1 1])
hold on
grid on


% First, plot some intermediate examples
fig4 = figure;
set(fig4, 'Color', [1 1 1])
hold on
grid on

plotexamples = [1, fix( [1/5 2/5 3/5 4/5]*numexp ), numexp];
for i=1:length( plotexamples)
    omegaval = 0.5;
     zomega = zomegavals(plotexamples(i));
     zomegan = ( zomega.^ns );
     
     colnum = ceil(numcol*plotexamples(i)/numexp);
     col = mymap( colnum ,:);
     
     fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*zomegan;
     Nomega = sum(fusedcard);
     fusedcard =  fusedcard/Nomega;
     
     figure( fig4 )
     hold on
     plot( ns, fusedcard, '--','Color', col,'Linewidth',1.5 )
end

legendstr = {};
for i=1:length( plotexamples )
    legendstr{i} = num2str( zomegavals( plotexamples(i)) );
end
legend( legendstr );

plot( ns, card1, 'b', 'linewidth', 2 )
plot( ns, card2, 'g', 'linewidth', 2 )  
axis([20 max(ns) 0 1])
set( gca, 'XtickMode', 'auto' )
set( gca, 'FontSize', 14 )




for i=1:numexp

    colnum = ceil(numcol*i/numexp);
    col = mymap( colnum ,:);
    
    zomega = zomegavals(i);
    
    zomegan = ( zomega.^ns );
    
    for j=1:length( omegavals )
        
        omegaval = omegavals( j );
        expseries = ( card1.^(1-omegaval) ).*( card2.^omegaval );
        
        bndratio = minseries./expseries;
        bndratio( isnan( bndratio ) ) = 1;

        gamma_ = min ( bndratio );
        
        fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*zomegan;
        Nomega = sum(fusedcard);
        fusedcard =  fusedcard/Nomega;
        
        [mval, mind] = max(fusedcard);
        mapvals(i,j) = ns(mind); 

        incbound = ( Nomega*bndratio ).^(1./ns) ;% Inconsistency bound
        
        ntilde = log(  Nomega*gamma_)/log( zomega );
        ntildes(i,j) = ntilde;
        
        figure( fig4 )
        hold on
        plot( ns, fusedcard, ':','Color', col )
        
    end

      
    optstr1 = ['''color'',[', num2str(col) ,'],''linestyle'',''-'''];
    optstr2 = ['''color'',[', num2str(col) ,'],''linestyle'',''-.'''];
    figure( fig1 )
    hold on
    plot( omegavals ,  ntildes(i,:),  'color', col )
    
    figure( fig2 )
    hold on
    plot( ns ,incbound, 'color', col )
    
    drawnow;
end
drawnow;


fh = fig1;
figure( fig1 )
set(fh, 'Color', [1 1 1])
axis([0 max(ns) 0 1])
colormap( mymap );
cbh = colorbar( 'peer', gca );
set( cbh, 'Ticks', [ zomegavals(fix(numexp/6)) zomegavals(fix(3*numexp/6)) zomegavals(fix(5*numexp/6)) ],...
    'TickLabels', {num2str( zomegavals(fix(numexp/6)) ), num2str( zomegavals(fix(3*numexp/6)) ) , num2str( zomegavals(fix(5*numexp/6)) ) } );

[xx,yy] = meshgrid(omegavals, zomegavals );
fig3 = figure;
set( fig3, 'Color', [1 1 1] );
surf(xx,yy, mapvals  )
shading flat
view(0,90)






