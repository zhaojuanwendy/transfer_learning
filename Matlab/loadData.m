function[S_x,S_y,T_x,T_y] = loadData(file_path)
addpath(file_path)
s_x_file = fullfile(file_path,'source.x.dat')
s_y_file = fullfile(file_path,'source.y.dat')
t_x_file = fullfile(file_path,'target.x.dat')
t_y_file = fullfile(file_path,'target.y.dat')

S_x = load(s_x_file);
S_y = load(s_y_file);
T_x = load(t_x_file);
T_y = load(t_y_file);