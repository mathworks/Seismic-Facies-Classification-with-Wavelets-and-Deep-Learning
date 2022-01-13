function SliceViewUI(Cube,Xp,Yp,Zp,Clim,Cmap,View,AspectRatio,Cfactor)
if nargin < 9, Cfactor = 2; end
if nargin < 8, AspectRatio=[1,1,4]; end
if nargin < 7, View=[60 5]; end
if nargin < 6, Cmap=gray; end
if nargin < 5, Clim=max(abs(Cube(:)))*[-1 1]; end
if nargin < 4, Zp=1; end
if nargin < 3, Yp=1; end
if nargin < 2, Xp=1; end
[Nz,Nx,Ny]=size(Cube);
H = gcf;
% SLIDER BUTTONS
Pan = uipanel(H,'Position',[0 0 1 .1],'BorderWidth',0);
cx  = uicontrol('Parent',Pan,'Style','slider','Position',[50  50 100 10]); 
cy  = uicontrol('Parent',Pan,'Style','slider','Position',[200 50 100 10]);
cz  = uicontrol('Parent',Pan,'Style','slider','Position',[350 50 100 10]);
% LABELS
uicontrol('Parent',Pan,'Style','text','Position',[100,30,10,15],'String','X');
uicontrol('Parent',Pan,'Style','text','Position',[250,30,10,15],'String','Y');
uicontrol('Parent',Pan,'Style','text','Position',[400,30,10,15],'String','Z');
Px=uicontrol('Parent',Pan,'Style','text','Position',[75,60,60,15],'String',num2str(Xp));
Py=uicontrol('Parent',Pan,'Style','text','Position',[225,60,60,15],'String',num2str(Yp));
Pz=uicontrol('Parent',Pan,'Style','text','Position',[375,60,60,15],'String',num2str(Zp));
% SET INITIAL VALUES
cx.Value = Xp/Nx;
cy.Value = Yp/Ny;
cz.Value = Zp/Nz;
cx.SliderStep=1/Nx*[1 10];
cy.SliderStep=1/Ny*[1 10];
cz.SliderStep=1/Nz*[1 10];
cx.Callback = @DisplaySliceX;
cy.Callback = @DisplaySliceY;
cz.Callback = @DisplaySliceZ;
% THRESHOLD ADJUSTMENT
tup = uicontrol('Parent',Pan,'Style','pushbutton','String','Threshold UP','Position',[550 50 100 20]);
tdn = uicontrol('Parent',Pan,'Style','pushbutton','String','Threshold DOWN','Position',[550 20 100 20]);
tup.Callback = @IncreaseClim;
tdn.Callback = @DecreaseClim;
% COLORMAPS
cm1 = uicontrol('Parent',Pan,'Style','pushbutton','String','GRAY','Position',[750 60 100 15]);
cm2 = uicontrol('Parent',Pan,'Style','pushbutton','String','PARULA','Position',[750 40 100 15]);
cm3 = uicontrol('Parent',Pan,'Style','pushbutton','String','SEISMIC BWR','Position',[750 20 100 15]);
cm1.Callback = @Gray;
cm2.Callback = @Parula;
cm3.Callback = @BWR;
% DISPLAY INITIAL SLICES
Xim = Xp*[1 1; 1 1];
Yim = [1 Ny;  1 Ny];
Zim = [1  1; Nz Nz];
Slice = squeeze(Cube(:,Xp,:));
Hsx=surf(Xim,Yim,Zim,'CData',Slice,'FaceColor','texturemap','CDataMapping','scaled');
colormap(Cmap);
caxis(Clim);
hold on;
Yim = Yp*[1 1; 1 1];
Xim = [1 Nx;  1 Nx];
Zim = [1  1; Nz Nz];
Slice = squeeze(Cube(:,:,Yp));
Hsy=surf(Xim,Yim,Zim,'CData',Slice,'FaceColor','texturemap','CDataMapping','scaled');
colormap(Cmap);
caxis(Clim);
Zim = Zp*[1 1; 1 1];
Xim = [1 Nx;  1  Nx];
Yim = [1  1; Ny  Ny];
Slice = squeeze(Cube(Zp,:,:));
Hsz=surf(Xim,Yim,Zim,'CData',Slice,'FaceColor','texturemap','CDataMapping','scaled');
colormap(Cmap);
caxis(Clim);
set(gca,'zdir','reverse');
set(gca,'Xlim',[1 Nx]);
set(gca,'Ylim',[1 Ny]);
set(gca,'Zlim',[1 Nz]);
axis tight;
xlabel('X'); ylabel('Y'); zlabel('Z');
set(gca,'DataAspectRatio',AspectRatio);
view(View);
drawnow; figure(gcf);
% CALLBACK FUNCTIONS
    function DisplaySliceX(src,event)
        Xp  = max(1,floor(cx.Value*Nx));
        Xim = Xp*[1 1; 1 1];
        Yim = [1 Ny;  1 Ny];
        Zim = [1  1; Nz Nz];
        Slice = squeeze(Cube(:,Xp,:));
        delete(Hsx);
        Hsx=surf(Xim,Yim,Zim,'CData',Slice,'FaceColor','texturemap','CDataMapping','scaled');
        colormap(Cmap);
        caxis(Clim);
        delete(Px);
        Px=uicontrol('Parent',Pan,'Style','text','Position',[75,60,60,15],'String',num2str(Xp));
        drawnow;
    end
    function DisplaySliceY(src,event)
        Yp  = max(1,floor(cy.Value*Ny));
        Yim = Yp*[1 1; 1 1];
        Xim = [1 Nx;  1 Nx];
        Zim = [1  1; Nz Nz];
        Slice = squeeze(Cube(:,:,Yp));
        delete(Hsy);
        Hsy=surf(Xim,Yim,Zim,'CData',Slice,'FaceColor','texturemap','CDataMapping','scaled');
        colormap(Cmap);
        caxis(Clim);
        delete(Py);
        Py=uicontrol('Parent',Pan,'Style','text','Position',[225,60,60,15],'String',num2str(Yp));
        drawnow;
    end
    function DisplaySliceZ(src,event)
        Zp  = max(1,floor(cz.Value*Nz));
        Zim = Zp*[1 1; 1 1];
        Xim = [1 Nx;  1  Nx];
        Yim = [1  1; Ny  Ny];
        Slice = squeeze(Cube(Zp,:,:));
        delete(Hsz);
        Hsz=surf(Xim,Yim,Zim,'CData',Slice,'FaceColor','texturemap','CDataMapping','scaled');
        colormap(Cmap);
        caxis(Clim);
        delete(Pz);
        Pz=uicontrol('Parent',Pan,'Style','text','Position',[375,60,60,15],'String',num2str(Zp));
        drawnow;
    end
    function IncreaseClim(src,event)
        Clim = Cfactor*Clim;
        DisplaySliceX;
        DisplaySliceY;
        DisplaySliceZ;
        drawnow;
    end
    function DecreaseClim(src,event)
        Clim = Clim/Cfactor;
        DisplaySliceX;
        DisplaySliceY;
        DisplaySliceZ;
        drawnow;
    end
    function Gray(src,event)
        Cmap=colormap(gray);
    end
    function Parula(src,event)
        Cmap=colormap(parula);
    end
    function BWR(src,event)
        Cmap=colormap(BWRcolormap);
    end
end