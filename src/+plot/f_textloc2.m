function [tx,ty] = textloc(ax, pre)
    % ax = axis([xmin,xmax,ymin,ymax])
    % pre = (xpre,ypre) xpre and ypre means precents, eg. pre=[0.1,0.9]
    tx = ax(1)+pre(1)*(ax(2)-ax(1));
    ty = ax(3)+pre(2)*(ax(4)-ax(3));
end
