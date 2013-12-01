function calibrateJoystick(j)

% -0.2891    0.2620   -0.5703    0.5397

d_min = 0;
d_max = 0;
r_min = 0;
r_max = 0;

disp('Pyörittele tatteja 10sec');

for i=1:100
    a = read(j);
    
    if a(1) < d_min
        d_min = a(1);
    end
    
    if a(1) > d_max
        d_max = a(1);
    end
    
    if a(6) < r_min
        r_min = a(6);
    end
    
    if a(6) > r_max
        r_max = a(6);
    end
    
    pause(0.1);
    
end

[d_min d_max r_min r_max]

end