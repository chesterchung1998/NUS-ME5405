clear;
close all;

figure(1);
x = categorical({'one-vs-one','one-vs-all'});
x = reordercats(x,{'one-vs-one','one-vs-all'});
y = [93.8 94.1];
b = bar(x,y);
b.FaceColor = 'flat';
b.CData(2,:) = [0 0.7 0];
ylim([93 95]);
xlabel("Multiclass Method");
ylabel("Accuracy of classifier (%)");
text(1:length(y),y,num2str(y'),"HorizontalAlignment","center","VerticalAlignment","bottom"); 
title('Accuracy vs Multiclass Method (SVM classifier)');

figure(2);
yyaxis left
x = categorical({'linear','gaussian','polynomial (2nd order)', 'polynomial (3rd order)', 'polynomial (4th order)'});
x = reordercats(x,{'linear','gaussian','polynomial (2nd order)', 'polynomial (3rd order)', 'polynomial (4th order)'});
y = [94.1 68.7 94.9 95.1 94.8];
b = bar(x,y);
ylim([67 98]);
xlabel("Kernel Function");
ylabel("Accuracy of classifier (%)");
text(1:length(y),y,num2str(y'),"HorizontalAlignment","center","VerticalAlignment","bottom","Color",[0 0.4 0.8]); 
title('Accuracy/Run Time vs Kernel Function (SVM classifier)');

yyaxis right
z = [6 100 7 302 625];
p = plot(x, z);
p.LineWidth = 2;
ylabel("Run Time (s)");