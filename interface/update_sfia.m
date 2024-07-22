function update_sfia(src, ~, subfig, aisc_section_type)
    index2=get(src, 'Value');
    % [labels,data] = complexdata();
    % complex_folderPath = 'helpers\complex_sections_data\';
    [aisc_section_type] = {'W'; 'M'; 'S'; 'HP'; 'C'; 'MC'; 'L'; 'WT'; 'MT'; 'ST'; 'HSS'; 'PIPE'};
    section_type_id = aisc_section_type(index2);
    % Extract the string from the cell array
    section_type_String = section_type_id{1};
    
    



    save('helpers\complex_sections_data\section_type_String', 'section_type_String');
    %%%%%%%%%
    aisc_section_type = {'W'; 'M'; 'S'; 'HP'; 'C'; 'MC'; 'L'; 'WT'; 'MT'; 'ST'; 'HSS'; 'PIPE'};

    % Create a structure with arrays for each section type
    W_array = {'W44X408'; 'W44X368'; 'W44X335'; 'W44X290'; 'W44X262'; 'W44X230'; 'W40X655'; 'W40X593'; 'W40X503'; 'W40X431'; 'W40X397'; 'W40X372'; 'W40X362'; 'W40X324'; 'W40X297'; 'W40X277'; 'W40X249'; 'W40X215'; 'W40X199'; 'W40X392'; 'W40X331'; 'W40X327'; 'W40X294'; 'W40X278'; 'W40X264'; 'W40X235'; 'W40X211'; 'W40X183'; 'W40X167'; 'W40X149'; 'W36X925'; 'W36X853'; 'W36X802'; 'W36X723'; 'W36X652'; 'W36X529'; 'W36X487'; 'W36X441'; 'W36X395'; 'W36X361'; 'W36X330'; 'W36X302'; 'W36X282'; 'W36X262'; 'W36X247'; 'W36X231'; 'W36X387'; 'W36X350'; 'W36X318'; 'W36X286'; 'W36X256'; 'W36X232'; 'W36X210'; 'W36X194'; 'W36X182'; 'W36X170'; 'W36X160'; 'W36X150'; 'W36X135'; 'W33X387'; 'W33X354'; 'W33X318'; 'W33X291'; 'W33X263'; 'W33X241'; 'W33X221'; 'W33X201'; 'W33X169'; 'W33X152'; 'W33X141'; 'W33X130'; 'W33X118'; 'W30X391'; 'W30X357'; 'W30X326'; 'W30X292'; 'W30X261'; 'W30X235'; 'W30X211'; 'W30X191'; 'W30X173'; 'W30X148'; 'W30X132'; 'W30X124'; 'W30X116'; 'W30X108'; 'W30X99'; 'W30X90'; 'W27X539'; 'W27X368'; 'W27X336'; 'W27X307'; 'W27X281'; 'W27X258'; 'W27X235'; 'W27X217'; 'W27X194'; 'W27X178'; 'W27X161'; 'W27X146'; 'W27X129'; 'W27X114'; 'W27X102'; 'W27X94'; 'W27X84'; 'W24X370'; 'W24X335'; 'W24X306'; 'W24X279'; 'W24X250'; 'W24X229'; 'W24X207'; 'W24X192'; 'W24X176'; 'W24X162'; 'W24X146'; 'W24X131'; 'W24X117'; 'W24X104'; 'W24X103'; 'W24X94'; 'W24X84'; 'W24X76'; 'W24X68'; 'W24X62'; 'W24X55'; 'W21X275'; 'W21X248'; 'W21X223'; 'W21X201'; 'W21X182'; 'W21X166'; 'W21X147'; 'W21X132'; 'W21X122'; 'W21X111'; 'W21X101'; 'W21X93'; 'W21X83'; 'W21X73'; 'W21X68'; 'W21X62'; 'W21X55'; 'W21X48'; 'W21X57'; 'W21X50'; 'W21X44'; 'W18X311'; 'W18X283'; 'W18X258'; 'W18X234'; 'W18X211'; 'W18X192'; 'W18X175'; 'W18X158'; 'W18X143'; 'W18X130'; 'W18X119'; 'W18X106'; 'W18X97'; 'W18X86'; 'W18X76'; 'W18X71'; 'W18X65'; 'W18X60'; 'W18X55'; 'W18X50'; 'W18X46'; 'W18X40'; 'W18X35'; 'W16X100'; 'W16X89'; 'W16X77'; 'W16X67'; 'W16X57'; 'W16X50'; 'W16X45'; 'W16X40'; 'W16X36'; 'W16X31'; 'W16X26'; 'W14X873'; 'W14X808'; 'W14X730'; 'W14X665'; 'W14X605'; 'W14X550'; 'W14X500'; 'W14X455'; 'W14X426'; 'W14X398'; 'W14X370'; 'W14X342'; 'W14X311'; 'W14X283'; 'W14X257'; 'W14X233'; 'W14X211'; 'W14X193'; 'W14X176'; 'W14X159'; 'W14X145'; 'W14X132'; 'W14X120'; 'W14X109'; 'W14X99'; 'W14X90'; 'W14X82'; 'W14X74'; 'W14X68'; 'W14X61'; 'W14X53'; 'W14X48'; 'W14X43'; 'W14X38'; 'W14X34'; 'W14X30'; 'W14X26'; 'W14X22'; 'W12X336'; 'W12X305'; 'W12X279'; 'W12X252'; 'W12X230'; 'W12X210'; 'W12X190'; 'W12X170'; 'W12X152'; 'W12X136'; 'W12X120'; 'W12X106'; 'W12X96'; 'W12X87'; 'W12X79'; 'W12X72'; 'W12X65'; 'W12X58'; 'W12X53'; 'W12X50'; 'W12X45'; 'W12X40'; 'W12X35'; 'W12X30'; 'W12X26'; 'W12X22'; 'W12X19'; 'W12X16'; 'W12X14'; 'W10X112'; 'W10X100'; 'W10X88'; 'W10X77'; 'W10X68'; 'W10X60'; 'W10X54'; 'W10X49'; 'W10X45'; 'W10X39'; 'W10X33'; 'W10X30'; 'W10X26'; 'W10X22'; 'W10X19'; 'W10X17'; 'W10X15'; 'W10X12'; 'W8X67'; 'W8X58'; 'W8X48'; 'W8X40'; 'W8X35'; 'W8X31'; 'W8X28'; 'W8X24'; 'W8X21'; 'W8X18'; 'W8X15'; 'W8X13'; 'W8X10'; 'W6X25'; 'W6X20'; 'W6X15'; 'W6X16'; 'W6X12'; 'W6X9'; 'W6X8p5'; 'W5X19'; 'W5X16'; 'W4X13'};
    M_array = {'M12p5X12p4'; 'M12p5X11p6'; 'M12X11p8'; 'M12X10p8'; 'M12X10'; 'M10X9'; 'M10X8'; 'M10X7p5'; 'M8X6p5'; 'M8X6p2'; 'M6X4p4'; 'M6X3p7'; 'M5X18p9'; 'M4X6'; 'M4X4p08'; 'M3X2p9'};
    S_array = {'S24X121'; 'S24X106'; 'S24X100'; 'S24X90'; 'S24X80'; 'S20X96'; 'S20X86'; 'S20X75'; 'S20X66'; 'S18X70'; 'S18X54p7'; 'S15X50'; 'S15X42p9'; 'S12X50'; 'S12X40p8'; 'S12X35'; 'S12X31p8'; 'S10X35'; 'S10X25p4'; 'S8X23'; 'S8X18p4'; 'S6X17p25'; 'S6X12p5'; 'S5X10'; 'S4X9p5'; 'S4X7p7'; 'S3X7p5'; 'S3X5p7'};
    HP_array = {'HP18X204'; 'HP18X181'; 'HP18X157'; 'HP18X135'; 'HP16X183'; 'HP16X162'; 'HP16X141'; 'HP16X121'; 'HP16X101'; 'HP16X88'; 'HP14X117'; 'HP14X102'; 'HP14X89'; 'HP14X73'; 'HP12X89'; 'HP12X84'; 'HP12X74'; 'HP12X63'; 'HP12X53'; 'HP10X57'; 'HP10X42'; 'HP8X36'};
    C_array = {'C15X50'; 'C15X40'; 'C15X33p9'; 'C12X30'; 'C12X25'; 'C12X20p7'; 'C10X30'; 'C10X25'; 'C10X20'; 'C10X15p3'; 'C9X20'; 'C9X15'; 'C9X13p4'; 'C8X18p75'; 'C8X13p75'; 'C8X11p5'; 'C7X14p75'; 'C7X12p25'; 'C7X9p8'; 'C6X13'; 'C6X10p5'; 'C6X8p2'; 'C5X9'; 'C5X6p7'; 'C4X7p25'; 'C4X6p25'; 'C4X5p4'; 'C4X4p5'; 'C3X6'; 'C3X5'; 'C3X4p1'; 'C3X3p5'};
    MC_array = {'MC18X58'; 'MC18X51p9'; 'MC18X45p8'; 'MC18X42p7'; 'MC13X50'; 'MC13X40'; 'MC13X35'; 'MC13X31p8'; 'MC12X50'; 'MC12X45'; 'MC12X40'; 'MC12X35'; 'MC12X31'; 'MC12X14p3'; 'MC12X10p6'; 'MC10X41p1'; 'MC10X33p6'; 'MC10X28p5'; 'MC10X25'; 'MC10X22'; 'MC10X8p4'; 'MC10X6p5'; 'MC9X25p4'; 'MC9X23p9'; 'MC8X22p8'; 'MC8X21p4'; 'MC8X20'; 'MC8X18p7'; 'MC8X8p5'; 'MC7X22p7'; 'MC7X19p1'; 'MC6X18'; 'MC6X15p3'; 'MC6X16p3'; 'MC6X15p1'; 'MC6X12'; 'MC6X7'; 'MC6X6p5'; 'MC4X13p8'; 'MC3X7p1'};
    L_array = {'L12X12X1-3f8'; 'L12X12X1-1f4'; 'L12X12X1-1f8'; 'L12X12X1'; 'L10X10X1-3f8'; 'L10X10X1-1f4'; 'L10X10X1-1f8'; 'L10X10X1'; 'L10X10X7f8'; 'L10X10X3f4'; 'L8X8X1-1f8'; 'L8X8X1'; 'L8X8X7f8'; 'L8X8X3f4'; 'L8X8X5f8'; 'L8X8X9f16'; 'L8X8X1f2'; 'L8X6X1'; 'L8X6X7f8'; 'L8X6X3f4'; 'L8X6X5f8'; 'L8X6X9f16'; 'L8X6X1f2'; 'L8X6X7f16'; 'L8X4X1'; 'L8X4X7f8'; 'L8X4X3f4'; 'L8X4X5f8'; 'L8X4X9f16'; 'L8X4X1f2'; 'L8X4X7f16'; 'L7X4X3f4'; 'L7X4X5f8'; 'L7X4X1f2'; 'L7X4X7f16'; 'L7X4X3f8'; 'L6X6X1'; 'L6X6X7f8'; 'L6X6X3f4'; 'L6X6X5f8'; 'L6X6X9f16'; 'L6X6X1f2'; 'L6X6X7f16'; 'L6X6X3f8'; 'L6X6X5f16'; 'L6X4X7f8'; 'L6X4X3f4'; 'L6X4X5f8'; 'L6X4X9f16'; 'L6X4X1f2'; 'L6X4X7f16'; 'L6X4X3f8'; 'L6X4X5f16'; 'L6X3-1f2X1f2'; 'L6X3-1f2X3f8'; 'L6X3-1f2X5f16'; 'L5X5X7f8'; 'L5X5X3f4'; 'L5X5X5f8'; 'L5X5X1f2'; 'L5X5X7f16'; 'L5X5X3f8'; 'L5X5X5f16'; 'L5X3-1f2X3f4'; 'L5X3-1f2X5f8'; 'L5X3-1f2X1f2'; 'L5X3-1f2X3f8'; 'L5X3-1f2X5f16'; 'L5X3-1f2X1f4'; 'L5X3X1f2'; 'L5X3X7f16'; 'L5X3X3f8'; 'L5X3X5f16'; 'L5X3X1f4'; 'L4X4X3f4'; 'L4X4X5f8'; 'L4X4X1f2'; 'L4X4X7f16'; 'L4X4X3f8'; 'L4X4X5f16'; 'L4X4X1f4'; 'L4X3-1f2X1f2'; 'L4X3-1f2X3f8'; 'L4X3-1f2X5f16'; 'L4X3-1f2X1f4'; 'L4X3X5f8'; 'L4X3X1f2'; 'L4X3X3f8'; 'L4X3X5f16'; 'L4X3X1f4'; 'L3-1f2X3-1f2X1f2'; 'L3-1f2X3-1f2X7f16'; 'L3-1f2X3-1f2X3f8'; 'L3-1f2X3-1f2X5f16'; 'L3-1f2X3-1f2X1f4'; 'L3-1f2X3X1f2'; 'L3-1f2X3X7f16'; 'L3-1f2X3X3f8'; 'L3-1f2X3X5f16'; 'L3-1f2X3X1f4'; 'L3-1f2X2-1f2X1f2'; 'L3-1f2X2-1f2X3f8'; 'L3-1f2X2-1f2X5f16'; 'L3-1f2X2-1f2X1f4'; 'L3X3X1f2'; 'L3X3X7f16'; 'L3X3X3f8'; 'L3X3X5f16'; 'L3X3X1f4'; 'L3X3X3f16'; 'L3X2-1f2X1f2'; 'L3X2-1f2X7f16'; 'L3X2-1f2X3f8'; 'L3X2-1f2X5f16'; 'L3X2-1f2X1f4'; 'L3X2-1f2X3f16'; 'L3X2X1f2'; 'L3X2X3f8'; 'L3X2X5f16'; 'L3X2X1f4'; 'L3X2X3f16'; 'L2-1f2X2-1f2X1f2'; 'L2-1f2X2-1f2X3f8'; 'L2-1f2X2-1f2X5f16'; 'L2-1f2X2-1f2X1f4'; 'L2-1f2X2-1f2X3f16'; 'L2-1f2X2X3f8'; 'L2-1f2X2X5f16'; 'L2-1f2X2X1f4'; 'L2-1f2X2X3f16'; 'L2-1f2X1-1f2X1f4'; 'L2-1f2X1-1f2X3f16'; 'L2X2X3f8'; 'L2X2X5f16'; 'L2X2X1f4'; 'L2X2X3f16'; 'L2X2X1f8'};
    WT_array = {'WT22X204'; 'WT22X184'; 'WT22X167p5'; 'WT22X145'; 'WT22X131'; 'WT22X115'; 'WT20X327p5'; 'WT20X296p5'; 'WT20X251p5'; 'WT20X215p5'; 'WT20X198p5'; 'WT20X186'; 'WT20X181'; 'WT20X162'; 'WT20X148p5'; 'WT20X138p5'; 'WT20X124p5'; 'WT20X107p5'; 'WT20X99p5'; 'WT20X196'; 'WT20X165p5'; 'WT20X163p5'; 'WT20X147'; 'WT20X139'; 'WT20X132'; 'WT20X117p5'; 'WT20X105p5'; 'WT20X91p5'; 'WT20X83p5'; 'WT20X74p5'; 'WT18X462p5'; 'WT18X426p5'; 'WT18X401'; 'WT18X361p5'; 'WT18X326'; 'WT18X264p5'; 'WT18X243p5'; 'WT18X220p5'; 'WT18X197p5'; 'WT18X180p5'; 'WT18X165'; 'WT18X151'; 'WT18X141'; 'WT18X131'; 'WT18X123p5'; 'WT18X115p5'; 'WT18X193p5'; 'WT18X175'; 'WT18X159'; 'WT18X143'; 'WT18X128'; 'WT18X116'; 'WT18X105'; 'WT18X97'; 'WT18X91'; 'WT18X85'; 'WT18X80'; 'WT18X75'; 'WT18X67p5'; 'WT16p5X193p5'; 'WT16p5X177'; 'WT16p5X159'; 'WT16p5X145p5'; 'WT16p5X131p5'; 'WT16p5X120p5'; 'WT16p5X110p5'; 'WT16p5X100p5'; 'WT16p5X84p5'; 'WT16p5X76'; 'WT16p5X70p5'; 'WT16p5X65'; 'WT16p5X59'; 'WT15X195p5'; 'WT15X178p5'; 'WT15X163'; 'WT15X146'; 'WT15X130p5'; 'WT15X117p5'; 'WT15X105p5'; 'WT15X95p5'; 'WT15X86p5'; 'WT15X74'; 'WT15X66'; 'WT15X62'; 'WT15X58'; 'WT15X54'; 'WT15X49p5'; 'WT15X45'; 'WT13p5X269p5'; 'WT13p5X184'; 'WT13p5X168'; 'WT13p5X153p5'; 'WT13p5X140p5'; 'WT13p5X129'; 'WT13p5X117p5'; 'WT13p5X108p5'; 'WT13p5X97'; 'WT13p5X89'; 'WT13p5X80p5'; 'WT13p5X73'; 'WT13p5X64p5'; 'WT13p5X57'; 'WT13p5X51'; 'WT13p5X47'; 'WT13p5X42'; 'WT12X185'; 'WT12X167p5'; 'WT12X153'; 'WT12X139p5'; 'WT12X125'; 'WT12X114p5'; 'WT12X103p5'; 'WT12X96'; 'WT12X88'; 'WT12X81'; 'WT12X73'; 'WT12X65p5'; 'WT12X58p5'; 'WT12X52'; 'WT12X51p5'; 'WT12X47'; 'WT12X42'; 'WT12X38'; 'WT12X34'; 'WT12X31'; 'WT12X27p5'; 'WT10p5X137p5'; 'WT10p5X124'; 'WT10p5X111p5'; 'WT10p5X100p5'; 'WT10p5X91'; 'WT10p5X83'; 'WT10p5X73p5'; 'WT10p5X66'; 'WT10p5X61'; 'WT10p5X55p5'; 'WT10p5X50p5'; 'WT10p5X46p5'; 'WT10p5X41p5'; 'WT10p5X36p5'; 'WT10p5X34'; 'WT10p5X31'; 'WT10p5X27p5'; 'WT10p5X24'; 'WT10p5X28p5'; 'WT10p5X25'; 'WT10p5X22'; 'WT9X155p5'; 'WT9X141p5'; 'WT9X129'; 'WT9X117'; 'WT9X105p5'; 'WT9X96'; 'WT9X87p5'; 'WT9X79'; 'WT9X71p5'; 'WT9X65'; 'WT9X59p5'; 'WT9X53'; 'WT9X48p5'; 'WT9X43'; 'WT9X38'; 'WT9X35p5'; 'WT9X32p5'; 'WT9X30'; 'WT9X27p5'; 'WT9X25'; 'WT9X23'; 'WT9X20'; 'WT9X17p5'; 'WT8X50'; 'WT8X44p5'; 'WT8X38p5'; 'WT8X33p5'; 'WT8X28p5'; 'WT8X25'; 'WT8X22p5'; 'WT8X20'; 'WT8X18'; 'WT8X15p5'; 'WT8X13'; 'WT7X436p5'; 'WT7X404'; 'WT7X365'; 'WT7X332p5'; 'WT7X302p5'; 'WT7X275'; 'WT7X250'; 'WT7X227p5'; 'WT7X213'; 'WT7X199'; 'WT7X185'; 'WT7X171'; 'WT7X155p5'; 'WT7X141p5'; 'WT7X128p5'; 'WT7X116p5'; 'WT7X105p5'; 'WT7X96p5'; 'WT7X88'; 'WT7X79p5'; 'WT7X72p5'; 'WT7X66'; 'WT7X60'; 'WT7X54p5'; 'WT7X49p5'; 'WT7X45'; 'WT7X41'; 'WT7X37'; 'WT7X34'; 'WT7X30p5'; 'WT7X26p5'; 'WT7X24'; 'WT7X21p5'; 'WT7X19'; 'WT7X17'; 'WT7X15'; 'WT7X13'; 'WT7X11'; 'WT6X168'; 'WT6X152p5'; 'WT6X139p5'; 'WT6X126'; 'WT6X115'; 'WT6X105'; 'WT6X95'; 'WT6X85'; 'WT6X76'; 'WT6X68'; 'WT6X60'; 'WT6X53'; 'WT6X48'; 'WT6X43p5'; 'WT6X39p5'; 'WT6X36'; 'WT6X32p5'; 'WT6X29'; 'WT6X26p5'; 'WT6X25'; 'WT6X22p5'; 'WT6X20'; 'WT6X17p5'; 'WT6X15'; 'WT6X13'; 'WT6X11'; 'WT6X9p5'; 'WT6X8'; 'WT6X7'; 'WT5X56'; 'WT5X50'; 'WT5X44'; 'WT5X38p5'; 'WT5X34'; 'WT5X30'; 'WT5X27'; 'WT5X24p5'; 'WT5X22p5'; 'WT5X19p5'; 'WT5X16p5'; 'WT5X15'; 'WT5X13'; 'WT5X11'; 'WT5X9p5'; 'WT5X8p5'; 'WT5X7p5'; 'WT5X6'; 'WT4X33p5'; 'WT4X29'; 'WT4X24'; 'WT4X20'; 'WT4X17p5'; 'WT4X15p5'; 'WT4X14'; 'WT4X12'; 'WT4X10p5'; 'WT4X9'; 'WT4X7p5'; 'WT4X6p5'; 'WT4X5'; 'WT3X12p5'; 'WT3X10'; 'WT3X7p5'; 'WT3X8'; 'WT3X6'; 'WT3X4p5'; 'WT3X4p25'; 'WT2p5X9p5'; 'WT2p5X8'; 'WT2X6p5'};
    MT_array = {'MT6p25X6p2'; 'MT6p25X5p8'; 'MT6X5p9'; 'MT6X5p4'; 'MT6X5'; 'MT5X4p5'; 'MT5X4'; 'MT5X3p75'; 'MT4X3p25'; 'MT4X3p1'; 'MT3X2p2'; 'MT3X1p85'; 'MT2p5X9p45'; 'MT2X3'};
    ST_array = {'ST12X60p5'; 'ST12X53'; 'ST12X50'; 'ST12X45'; 'ST12X40'; 'ST10X48'; 'ST10X43'; 'ST10X37p5'; 'ST10X33'; 'ST9X35'; 'ST9X27p35'; 'ST7p5X25'; 'ST7p5X21p45'; 'ST6X25'; 'ST6X20p4'; 'ST6X17p5'; 'ST6X15p9'; 'ST5X17p5'; 'ST5X12p7'; 'ST4X11p5'; 'ST4X9p2'; 'ST3X8p6'; 'ST3X6p25'; 'ST2p5X5'; 'ST2X4p75'; 'ST2X3p85'; 'ST1p5X3p75'; 'ST1p5X2p85'};
    HSS_array = {'HSS34X10X1'; 'HSS34X10X7f8'; 'HSS34X10X3f4'; 'HSS34X10X5f8'; 'HSS30X10X1'; 'HSS30X10X7f8'; 'HSS30X10X3f4'; 'HSS30X10X5f8'; 'HSS30X10X1f2'; 'HSS24X20X3f4'; 'HSS24X20X5f8'; 'HSS24X20X1f2'; 'HSS24X20X3f8'; 'HSS24X20X5f16'; 'HSS24X18X3f4'; 'HSS24X18X5f8'; 'HSS24X18X1f2'; 'HSS24X18X3f8'; 'HSS24X18X5f16'; 'HSS24X16X3f4'; 'HSS24X16X5f8'; 'HSS24X16X1f2'; 'HSS24X16X3f8'; 'HSS24X16X5f16'; 'HSS24X14X3f4'; 'HSS24X14X5f8'; 'HSS24X14X1f2'; 'HSS24X14X3f8'; 'HSS24X14X5f16'; 'HSS24X14X1f4'; 'HSS24X12X1'; 'HSS24X12X7f8'; 'HSS24X12X3f4'; 'HSS24X12X5f8'; 'HSS24X12X1f2'; 'HSS24X12X3f8'; 'HSS24X12X5f16'; 'HSS24X12X1f4'; 'HSS24X8X1f2'; 'HSS24X8X3f8'; 'HSS24X8X5f16'; 'HSS24X8X1f4'; 'HSS22X22X1'; 'HSS22X22X7f8'; 'HSS22X22X3f4'; 'HSS22X22X5f8'; 'HSS22X22X1f2'; 'HSS22X20X3f4'; 'HSS22X20X5f8'; 'HSS22X20X1f2'; 'HSS22X20X3f8'; 'HSS22X20X5f16'; 'HSS22X18X3f4'; 'HSS22X18X5f8'; 'HSS22X18X1f2'; 'HSS22X18X3f8'; 'HSS22X18X5f16'; 'HSS22X16X3f4'; 'HSS22X16X5f8'; 'HSS22X16X1f2'; 'HSS22X16X3f8'; 'HSS22X16X5f16'; 'HSS22X16X1f4'; 'HSS22X14X3f4'; 'HSS22X14X5f8'; 'HSS22X14X1f2'; 'HSS22X14X3f8'; 'HSS22X14X5f16'; 'HSS22X14X1f4'; 'HSS22X10X5f8'; 'HSS22X10X1f2'; 'HSS22X10X3f8'; 'HSS22X10X5f16'; 'HSS22X10X1f4'; 'HSS20X20X1'; 'HSS20X20X7f8'; 'HSS20X20X3f4'; 'HSS20X20X5f8'; 'HSS20X20X1f2'; 'HSS20X20X3f8'; 'HSS20X20X5f16'; 'HSS20X16X3f4'; 'HSS20X16X5f8'; 'HSS20X16X1f2'; 'HSS20X16X3f8'; 'HSS20X16X5f16'; 'HSS20X16X1f4'; 'HSS20X12X1'; 'HSS20X12X7f8'; 'HSS20X12X3f4'; 'HSS20X12X5f8'; 'HSS20X12X1f2'; 'HSS20X12X3f8'; 'HSS20X12X5f16'; 'HSS20X8X1'; 'HSS20X8X7f8'; 'HSS20X8X3f4'; 'HSS20X8X5f8'; 'HSS20X8X1f2'; 'HSS20X8X3f8'; 'HSS20X8X5f16'; 'HSS20X6X5f8'; 'HSS20X6X1f2'; 'HSS20X6X3f8'; 'HSS20X6X5f16'; 'HSS20X6X1f4'; 'HSS20X4X1f2'; 'HSS20X4X3f8'; 'HSS20X4X5f16'; 'HSS20X4X1f4'; 'HSS18X18X1'; 'HSS18X18X7f8'; 'HSS18X18X3f4'; 'HSS18X18X5f8'; 'HSS18X18X1f2'; 'HSS18X18X3f8'; 'HSS18X18X5f16'; 'HSS18X18X1f4'; 'HSS18X10X5f8'; 'HSS18X10X1f2'; 'HSS18X10X3f8'; 'HSS18X10X5f16'; 'HSS18X10X1f4'; 'HSS18X8X5f8'; 'HSS18X8X1f2'; 'HSS18X8X3f8'; 'HSS18X8X5f16'; 'HSS18X8X1f4'; 'HSS18X6X3f4'; 'HSS18X6X5f8'; 'HSS18X6X1f2'; 'HSS18X6X3f8'; 'HSS18X6X5f16'; 'HSS18X6X1f4'; 'HSS16X16X1'; 'HSS16X16X7f8'; 'HSS16X16X3f4'; 'HSS16X16X5f8'; 'HSS16X16X1f2'; 'HSS16X16X3f8'; 'HSS16X16X5f16'; 'HSS16X16X1f4'; 'HSS16X12X1'; 'HSS16X12X7f8'; 'HSS16X12X3f4'; 'HSS16X12X5f8'; 'HSS16X12X1f2'; 'HSS16X12X3f8'; 'HSS16X12X5f16'; 'HSS16X10X5f8'; 'HSS16X10X1f2'; 'HSS16X10X3f8'; 'HSS16X10X5f16'; 'HSS16X10X1f4'; 'HSS16X8X7f8'; 'HSS16X8X3f4'; 'HSS16X8X5f8'; 'HSS16X8X1f2'; 'HSS16X8X3f8'; 'HSS16X8X5f16'; 'HSS16X8X1f4'; 'HSS16X6X5f8'; 'HSS16X6X1f2'; 'HSS16X6X3f8'; 'HSS16X6X5f16'; 'HSS16X6X1f4'; 'HSS16X6X3f16'; 'HSS16X4X5f8'; 'HSS16X4X1f2'; 'HSS16X4X3f8'; 'HSS16X4X5f16'; 'HSS16X4X1f4'; 'HSS16X4X3f16'; 'HSS14X14X1'; 'HSS14X14X7f8'; 'HSS14X14X3f4'; 'HSS14X14X5f8'; 'HSS14X14X1f2'; 'HSS14X14X3f8'; 'HSS14X14X5f16'; 'HSS14X14X1f4'; 'HSS14X12X5f8'; 'HSS14X12X1f2'; 'HSS14X12X3f8'; 'HSS14X12X5f16'; 'HSS14X12X1f4'; 'HSS14X10X7f8'; 'HSS14X10X3f4'; 'HSS14X10X5f8'; 'HSS14X10X1f2'; 'HSS14X10X3f8'; 'HSS14X10X5f16'; 'HSS14X10X1f4'; 'HSS14X8X5f8'; 'HSS14X8X1f2'; 'HSS14X8X3f8'; 'HSS14X8X5f16'; 'HSS14X8X1f4'; 'HSS14X8X3f16'; 'HSS14X6X5f8'; 'HSS14X6X1f2'; 'HSS14X6X3f8'; 'HSS14X6X5f16'; 'HSS14X6X1f4'; 'HSS14X6X3f16'; 'HSS14X4X5f8'; 'HSS14X4X1f2'; 'HSS14X4X3f8'; 'HSS14X4X5f16'; 'HSS14X4X1f4'; 'HSS14X4X3f16'; 'HSS12X12X1'; 'HSS12X12X7f8'; 'HSS12X12X3f4'; 'HSS12X12X5f8'; 'HSS12X12X1f2'; 'HSS12X12X3f8'; 'HSS12X12X5f16'; 'HSS12X12X1f4'; 'HSS12X12X3f16'; 'HSS12X10X5f8'; 'HSS12X10X1f2'; 'HSS12X10X3f8'; 'HSS12X10X5f16'; 'HSS12X10X1f4'; 'HSS12X10X3f16'; 'HSS12X8X5f8'; 'HSS12X8X1f2'; 'HSS12X8X3f8'; 'HSS12X8X5f16'; 'HSS12X8X1f4'; 'HSS12X8X3f16'; 'HSS12X6X5f8'; 'HSS12X6X1f2'; 'HSS12X6X3f8'; 'HSS12X6X5f16'; 'HSS12X6X1f4'; 'HSS12X6X3f16'; 'HSS12X4X5f8'; 'HSS12X4X1f2'; 'HSS12X4X3f8'; 'HSS12X4X5f16'; 'HSS12X4X1f4'; 'HSS12X4X3f16'; 'HSS12X3X5f16'; 'HSS12X3X1f4'; 'HSS12X3X3f16'; 'HSS12X2X5f16'; 'HSS12X2X1f4'; 'HSS12X2X3f16'; 'HSS10X10X3f4'; 'HSS10X10X5f8'; 'HSS10X10X1f2'; 'HSS10X10X3f8'; 'HSS10X10X5f16'; 'HSS10X10X1f4'; 'HSS10X10X3f16'; 'HSS10X8X5f8'; 'HSS10X8X1f2'; 'HSS10X8X3f8'; 'HSS10X8X5f16'; 'HSS10X8X1f4'; 'HSS10X8X3f16'; 'HSS10X6X5f8'; 'HSS10X6X1f2'; 'HSS10X6X3f8'; 'HSS10X6X5f16'; 'HSS10X6X1f4'; 'HSS10X6X3f16'; 'HSS10X5X3f8'; 'HSS10X5X5f16'; 'HSS10X5X1f4'; 'HSS10X4X5f8'; 'HSS10X4X1f2'; 'HSS10X4X3f8'; 'HSS10X4X5f16'; 'HSS10X4X1f4'; 'HSS10X4X3f16'; 'HSS10X4X1f8'; 'HSS10X3-1f2X3f8'; 'HSS10X3-1f2X5f16'; 'HSS10X3-1f2X1f4'; 'HSS10X3-1f2X3f16'; 'HSS10X3X3f8'; 'HSS10X3X5f16'; 'HSS10X3X1f4'; 'HSS10X3X3f16'; 'HSS10X3X1f8'; 'HSS10X2X3f8'; 'HSS10X2X5f16'; 'HSS10X2X1f4'; 'HSS10X2X3f16'; 'HSS10X2X1f8'; 'HSS9X9X5f8'; 'HSS9X9X1f2'; 'HSS9X9X3f8'; 'HSS9X9X5f16'; 'HSS9X9X1f4'; 'HSS9X9X3f16'; 'HSS9X9X1f8'; 'HSS9X7X5f8'; 'HSS9X7X1f2'; 'HSS9X7X3f8'; 'HSS9X7X5f16'; 'HSS9X7X1f4'; 'HSS9X7X3f16'; 'HSS9X5X5f8'; 'HSS9X5X1f2'; 'HSS9X5X3f8'; 'HSS9X5X5f16'; 'HSS9X5X1f4'; 'HSS9X5X3f16'; 'HSS9X3X1f2'; 'HSS9X3X3f8'; 'HSS9X3X5f16'; 'HSS9X3X1f4'; 'HSS9X3X3f16'; 'HSS8X8X5f8'; 'HSS8X8X1f2'; 'HSS8X8X3f8'; 'HSS8X8X5f16'; 'HSS8X8X1f4'; 'HSS8X8X3f16'; 'HSS8X8X1f8'; 'HSS8X6X5f8'; 'HSS8X6X1f2'; 'HSS8X6X3f8'; 'HSS8X6X5f16'; 'HSS8X6X1f4'; 'HSS8X6X3f16'; 'HSS8X4X5f8'; 'HSS8X4X1f2'; 'HSS8X4X3f8'; 'HSS8X4X5f16'; 'HSS8X4X1f4'; 'HSS8X4X3f16'; 'HSS8X4X1f8'; 'HSS8X3X1f2'; 'HSS8X3X3f8'; 'HSS8X3X5f16'; 'HSS8X3X1f4'; 'HSS8X3X3f16'; 'HSS8X3X1f8'; 'HSS8X2X1f2'; 'HSS8X2X3f8'; 'HSS8X2X5f16'; 'HSS8X2X1f4'; 'HSS8X2X3f16'; 'HSS8X2X1f8'; 'HSS7X7X5f8'; 'HSS7X7X1f2'; 'HSS7X7X3f8'; 'HSS7X7X5f16'; 'HSS7X7X1f4'; 'HSS7X7X3f16'; 'HSS7X7X1f8'; 'HSS7X5X1f2'; 'HSS7X5X3f8'; 'HSS7X5X5f16'; 'HSS7X5X1f4'; 'HSS7X5X3f16'; 'HSS7X5X1f8'; 'HSS7X4X1f2'; 'HSS7X4X3f8'; 'HSS7X4X5f16'; 'HSS7X4X1f4'; 'HSS7X4X3f16'; 'HSS7X4X1f8'; 'HSS7X3X1f2'; 'HSS7X3X3f8'; 'HSS7X3X5f16'; 'HSS7X3X1f4'; 'HSS7X3X3f16'; 'HSS7X3X1f8'; 'HSS7X2X1f4'; 'HSS7X2X3f16'; 'HSS7X2X1f8'; 'HSS6X6X5f8'; 'HSS6X6X1f2'; 'HSS6X6X3f8'; 'HSS6X6X5f16'; 'HSS6X6X1f4'; 'HSS6X6X3f16'; 'HSS6X6X1f8'; 'HSS6X5X1f2'; 'HSS6X5X3f8'; 'HSS6X5X5f16'; 'HSS6X5X1f4'; 'HSS6X5X3f16'; 'HSS6X5X1f8'; 'HSS6X4X1f2'; 'HSS6X4X3f8'; 'HSS6X4X5f16'; 'HSS6X4X1f4'; 'HSS6X4X3f16'; 'HSS6X4X1f8'; 'HSS6X3X1f2'; 'HSS6X3X3f8'; 'HSS6X3X5f16'; 'HSS6X3X1f4'; 'HSS6X3X3f16'; 'HSS6X3X1f8'; 'HSS6X2X3f8'; 'HSS6X2X5f16'; 'HSS6X2X1f4'; 'HSS6X2X3f16'; 'HSS6X2X1f8'; 'HSS5-1f2X5-1f2X3f8'; 'HSS5-1f2X5-1f2X5f16'; 'HSS5-1f2X5-1f2X1f4'; 'HSS5-1f2X5-1f2X3f16'; 'HSS5-1f2X5-1f2X1f8'; 'HSS5X5X1f2'; 'HSS5X5X3f8'; 'HSS5X5X5f16'; 'HSS5X5X1f4'; 'HSS5X5X3f16'; 'HSS5X5X1f8'; 'HSS5X4X1f2'; 'HSS5X4X3f8'; 'HSS5X4X5f16'; 'HSS5X4X1f4'; 'HSS5X4X3f16'; 'HSS5X4X1f8'; 'HSS5X3X1f2'; 'HSS5X3X3f8'; 'HSS5X3X5f16'; 'HSS5X3X1f4'; 'HSS5X3X3f16'; 'HSS5X3X1f8'; 'HSS5X2-1f2X1f4'; 'HSS5X2-1f2X3f16'; 'HSS5X2-1f2X1f8'; 'HSS5X2X3f8'; 'HSS5X2X5f16'; 'HSS5X2X1f4'; 'HSS5X2X3f16'; 'HSS5X2X1f8'; 'HSS4-1f2X4-1f2X1f2'; 'HSS4-1f2X4-1f2X3f8'; 'HSS4-1f2X4-1f2X5f16'; 'HSS4-1f2X4-1f2X1f4'; 'HSS4-1f2X4-1f2X3f16'; 'HSS4-1f2X4-1f2X1f8'; 'HSS4X4X1f2'; 'HSS4X4X3f8'; 'HSS4X4X5f16'; 'HSS4X4X1f4'; 'HSS4X4X3f16'; 'HSS4X4X1f8'; 'HSS4X3X3f8'; 'HSS4X3X5f16'; 'HSS4X3X1f4'; 'HSS4X3X3f16'; 'HSS4X3X1f8'; 'HSS4X2-1f2X1f4'; 'HSS4X2-1f2X3f16'; 'HSS4X2-1f2X1f8'; 'HSS4X2X3f8'; 'HSS4X2X5f16'; 'HSS4X2X1f4'; 'HSS4X2X3f16'; 'HSS4X2X1f8'; 'HSS4X1-1f2X1f4'; 'HSS4X1-1f2X3f16'; 'HSS4X1-1f2X1f8'; 'HSS3-1f2X3-1f2X3f8'; 'HSS3-1f2X3-1f2X5f16'; 'HSS3-1f2X3-1f2X1f4'; 'HSS3-1f2X3-1f2X3f16'; 'HSS3-1f2X3-1f2X1f8'; 'HSS3-1f2X2-1f2X3f8'; 'HSS3-1f2X2-1f2X5f16'; 'HSS3-1f2X2-1f2X1f4'; 'HSS3-1f2X2-1f2X3f16'; 'HSS3-1f2X2-1f2X1f8'; 'HSS3-1f2X2X1f4'; 'HSS3-1f2X2X3f16'; 'HSS3-1f2X2X1f8'; 'HSS3-1f2X1-1f2X1f4'; 'HSS3-1f2X1-1f2X3f16'; 'HSS3-1f2X1-1f2X1f8'; 'HSS3X3X3f8'; 'HSS3X3X5f16'; 'HSS3X3X1f4'; 'HSS3X3X3f16'; 'HSS3X3X1f8'; 'HSS3X2-1f2X5f16'; 'HSS3X2-1f2X1f4'; 'HSS3X2-1f2X3f16'; 'HSS3X2-1f2X1f8'; 'HSS3X2X5f16'; 'HSS3X2X1f4'; 'HSS3X2X3f16'; 'HSS3X2X1f8'; 'HSS3X1-1f2X1f4'; 'HSS3X1-1f2X3f16'; 'HSS3X1-1f2X1f8'; 'HSS3X1X3f16'; 'HSS3X1X1f8'; 'HSS2-1f2X2-1f2X5f16'; 'HSS2-1f2X2-1f2X1f4'; 'HSS2-1f2X2-1f2X3f16'; 'HSS2-1f2X2-1f2X1f8'; 'HSS2-1f2X2X1f4'; 'HSS2-1f2X2X3f16'; 'HSS2-1f2X2X1f8'; 'HSS2-1f2X1-1f2X1f4'; 'HSS2-1f2X1-1f2X3f16'; 'HSS2-1f2X1-1f2X1f8'; 'HSS2-1f2X1X3f16'; 'HSS2-1f2X1X1f8'; 'HSS2-1f4X2-1f4X1f4'; 'HSS2-1f4X2-1f4X3f16'; 'HSS2-1f4X2-1f4X1f8'; 'HSS2X2X1f4'; 'HSS2X2X3f16'; 'HSS2X2X1f8'; 'HSS2X1-1f2X3f16'; 'HSS2X1-1f2X1f8'; 'HSS2X1X3f16'; 'HSS2X1X1f8'; 'HSS1-1f2X1-1f2X1f4'; 'HSS1-1f2X1-1f2X3f16'; 'HSS1-1f2X1-1f2X1f8'; 'HSS28p000X1p000'; 'HSS28p000X0p875'; 'HSS28p000X0p750'; 'HSS28p000X0p625'; 'HSS28p000X0p500'; 'HSS28p000X0p375'; 'HSS26p000X0p750'; 'HSS26p000X0p625'; 'HSS26p000X0p500'; 'HSS26p000X0p375'; 'HSS26p000X0p313'; 'HSS24p000X1p000'; 'HSS24p000X0p875'; 'HSS24p000X0p750'; 'HSS24p000X0p625'; 'HSS24p000X0p500'; 'HSS24p000X0p375'; 'HSS24p000X0p313'; 'HSS22p000X0p750'; 'HSS22p000X0p625'; 'HSS22p000X0p500'; 'HSS22p000X0p375'; 'HSS22p000X0p313'; 'HSS20p000X1p000'; 'HSS20p000X0p875'; 'HSS20p000X0p750'; 'HSS20p000X0p625'; 'HSS20p000X0p500'; 'HSS20p000X0p375'; 'HSS20p000X0p313'; 'HSS20p000X0p250'; 'HSS18p000X1p000'; 'HSS18p000X0p875'; 'HSS18p000X0p750'; 'HSS18p000X0p625'; 'HSS18p000X0p500'; 'HSS18p000X0p375'; 'HSS18p000X0p313'; 'HSS18p000X0p250'; 'HSS16p000X1p000'; 'HSS16p000X0p875'; 'HSS16p000X0p750'; 'HSS16p000X0p625'; 'HSS16p000X0p500'; 'HSS16p000X0p438'; 'HSS16p000X0p375'; 'HSS16p000X0p312'; 'HSS16p000X0p250'; 'HSS14p000X1p000'; 'HSS14p000X0p875'; 'HSS14p000X0p750'; 'HSS14p000X0p625'; 'HSS14p000X0p500'; 'HSS14p000X0p375'; 'HSS14p000X0p312'; 'HSS14p000X0p250'; 'HSS14p000X0p188'; 'HSS13p375X0p625'; 'HSS13p375X0p500'; 'HSS13p375X0p375'; 'HSS13p375X0p313'; 'HSS13p375X0p250'; 'HSS13p375X0p188'; 'HSS12p750X0p750'; 'HSS12p750X0p625'; 'HSS12p750X0p500'; 'HSS12p750X0p375'; 'HSS12p750X0p250'; 'HSS12p750X0p188'; 'HSS12p000X0p625'; 'HSS12p000X0p500'; 'HSS12p000X0p375'; 'HSS12p000X0p250'; 'HSS11p750X0p625'; 'HSS11p750X0p500'; 'HSS11p750X0p375'; 'HSS11p750X0p337'; 'HSS11p750X0p250'; 'HSS10p750X0p625'; 'HSS10p750X0p500'; 'HSS10p750X0p375'; 'HSS10p750X0p313'; 'HSS10p750X0p250'; 'HSS10p750X0p188'; 'HSS10p000X0p625'; 'HSS10p000X0p500'; 'HSS10p000X0p375'; 'HSS10p000X0p312'; 'HSS10p000X0p250'; 'HSS10p000X0p188'; 'HSS9p625X0p625'; 'HSS9p625X0p500'; 'HSS9p625X0p375'; 'HSS9p625X0p312'; 'HSS9p625X0p250'; 'HSS9p625X0p188'; 'HSS8p625X0p625'; 'HSS8p625X0p500'; 'HSS8p625X0p375'; 'HSS8p625X0p322'; 'HSS8p625X0p250'; 'HSS8p625X0p188'; 'HSS7p500X0p500'; 'HSS7p500X0p375'; 'HSS7p500X0p312'; 'HSS7p500X0p250'; 'HSS7p500X0p188'; 'HSS7p000X0p500'; 'HSS7p000X0p375'; 'HSS7p000X0p312'; 'HSS7p000X0p250'; 'HSS7p000X0p188'; 'HSS7p000X0p125'; 'HSS6p875X0p375'; 'HSS6p875X0p312'; 'HSS6p875X0p250'; 'HSS6p875X0p188'; 'HSS6p625X0p500'; 'HSS6p625X0p432'; 'HSS6p625X0p375'; 'HSS6p625X0p312'; 'HSS6p625X0p280'; 'HSS6p625X0p250'; 'HSS6p625X0p188'; 'HSS6p625X0p125'; 'HSS6p000X0p500'; 'HSS6p000X0p375'; 'HSS6p000X0p312'; 'HSS6p000X0p280'; 'HSS6p000X0p250'; 'HSS6p000X0p188'; 'HSS6p000X0p125'; 'HSS5p563X0p500'; 'HSS5p563X0p375'; 'HSS5p563X0p258'; 'HSS5p563X0p188'; 'HSS5p563X0p134'; 'HSS5p500X0p500'; 'HSS5p500X0p375'; 'HSS5p500X0p258'; 'HSS5p000X0p500'; 'HSS5p000X0p375'; 'HSS5p000X0p312'; 'HSS5p000X0p258'; 'HSS5p000X0p250'; 'HSS5p000X0p188'; 'HSS5p000X0p125'; 'HSS4p500X0p375'; 'HSS4p500X0p337'; 'HSS4p500X0p237'; 'HSS4p500X0p188'; 'HSS4p500X0p125'; 'HSS4p000X0p313'; 'HSS4p000X0p250'; 'HSS4p000X0p237'; 'HSS4p000X0p226'; 'HSS4p000X0p220'; 'HSS4p000X0p188'; 'HSS4p000X0p125'; 'HSS3p500X0p313'; 'HSS3p500X0p300'; 'HSS3p500X0p250'; 'HSS3p500X0p216'; 'HSS3p500X0p203'; 'HSS3p500X0p188'; 'HSS3p500X0p125'; 'HSS3p000X0p250'; 'HSS3p000X0p216'; 'HSS3p000X0p203'; 'HSS3p000X0p188'; 'HSS3p000X0p152'; 'HSS3p000X0p134'; 'HSS3p000X0p125'; 'HSS2p875X0p250'; 'HSS2p875X0p203'; 'HSS2p875X0p188'; 'HSS2p875X0p125'; 'HSS2p500X0p250'; 'HSS2p500X0p188'; 'HSS2p500X0p125'; 'HSS2p375X0p250'; 'HSS2p375X0p218'; 'HSS2p375X0p188'; 'HSS2p375X0p154'; 'HSS2p375X0p125'; 'HSS1p900X0p188'; 'HSS1p900X0p145'; 'HSS1p900X0p120'; 'HSS1p660X0p140'};
    PIPE_array = {'Pipe26STD'; 'Pipe24STD'; 'Pipe20STD'; 'Pipe18STD'; 'Pipe16STD'; 'Pipe14STD'; 'Pipe12STD'; 'Pipe10STD'; 'Pipe8STD'; 'Pipe6STD'; 'Pipe5STD'; 'Pipe4STD'; 'Pipe3-1f2STD'; 'Pipe3STD'; 'Pipe2-1f2STD'; 'Pipe2STD'; 'Pipe1-1f2STD'; 'Pipe1-1f4STD'; 'Pipe1STD'; 'Pipe3f4STD'; 'Pipe1f2STD'; 'Pipe26XS'; 'Pipe24XS'; 'Pipe20XS'; 'Pipe18XS'; 'Pipe16XS'; 'Pipe14XS'; 'Pipe12XS'; 'Pipe10XS'; 'Pipe8XS'; 'Pipe6XS'; 'Pipe5XS'; 'Pipe4XS'; 'Pipe3-1f2XS'; 'Pipe3XS'; 'Pipe2-1f2XS'; 'Pipe2XS'; 'Pipe1-1f2XS'; 'Pipe1-1f4XS'; 'Pipe1XS'; 'Pipe3f4XS'; 'Pipe1f2XS'; 'Pipe12XXS'; 'Pipe10XXS'; 'Pipe8XXS'; 'Pipe6XXS'; 'Pipe5XXS'; 'Pipe4XXS'; 'Pipe3XXS'; 'Pipe2-1f2XXS'; 'Pipe2XXS'};

    % Define your section type string
    %section_type_String = 'W'; % This will be set to the desired section type
    load('helpers\complex_sections_data\section_type_String', 'section_type_String');
    section_type_String = section_type_String;
    % Use a switch statement to assign the labels variable based on section_type_String
    switch section_type_String
        case 'W'
            labels = W_array;
        case 'M'
            labels = M_array;
        case 'S'
            labels = S_array;
        case 'HP'
            labels = HP_array;
        case 'C'
            labels = C_array;
        case 'MC'
            labels = MC_array;
        case 'L'
            labels = L_array;
        case 'WT'
            labels = WT_array;
        case 'MT'
            labels = MT_array;
        case 'ST'
            labels = ST_array;
        case 'HSS'
            labels = HSS_array;
        case 'PIPE'
            labels = PIPE_array;
        otherwise
            error('Unknown section type: %s', section_type_String);
    end

    labels = labels;
    
    %%%%%%%%%%
    
    sfia = findobj(subfig, 'Tag', 'sfia_listbox');
    set(sfia, 'String', labels);
    
    set(sfia, 'Value', 1); % Always select the first item after updating
    % Trigger the sfia listbox callback function to activate the selection
    callback = get(sfia, 'Callback');
    if ~isempty(callback)
        if ischar(callback)
            eval(callback);
        elseif isa(callback, 'function_handle')
            callback(sfia, []);
        elseif iscell(callback)
            feval(callback{1}, sfia, [], callback{2:end});
        end
    end
end