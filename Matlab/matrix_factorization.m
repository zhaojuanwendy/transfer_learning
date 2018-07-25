function [e,step,P,Q] = matrix_factorization(R,k_dim,n,m,alpha,steps,P,Q)

% P = rand(m,K); 
% Q = rand(K,n); 
beta = 0.02
%m rows, n columns
for step = 1:steps
    for i = 1:m
        for j =1:n
            if R(i,j)>0
                eij= R(i,j)-P(i,:)*Q(:,j);
                for k = 1:k_dim
                    P(i,k) =  P(i,k) + alpha * (2 * eij * Q(k,j)-beta*P(i,k));
                    Q(k,j) =  Q(k,j) + alpha * (2 * eij * P(i,k)-beta*Q(k,j));
                end
            end
        end
    end
     eR = P*Q;
     e = 0;
      for i = 1:m
        for j =1:n
            if R(i,j)>0
                e = e + (R(i,j) - P(i,:)*Q(:,j))^2;
                for k = 1:1:k_dim
                     e = e + (beta/2) * ((P(i,k)^2) + (Q(k,j)^2))
                end
            end
        end
      end              
     if e<0.1
          break
     end
end
                    
        