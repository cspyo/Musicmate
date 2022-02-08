import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.swing.AbstractCellEditor;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.ScrollPaneConstants;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.table.TableColumnModel;

public class MainFrame {

	Connection conn; // DB 연결 Connection 객체참조변수
	JFrame mainFrame;
	JTextField search;
	JTextArea lyrics;
	JButton adminB,searchB, likeB,like2B;
	JLabel likeL;
	PlayListFrame playFrame;
	MainPanel mainPanel;
	JScrollPane mainSC, lyricSC;
	JTable mainT;
	int USER;
	int f_xpos,f_ypos;
	int f_wid = 1000, f_hgt = 800;
	String[] header = {"순위","노래제목","가수","정보","담기"};
	String contents[][];
	String nowAlbum = "none";
	String song;
	DefaultTableModel model;


	MainFrame(int user){
		this.USER = user;
	}

	public void go() {
		dbConnectionInit();
		setUpGUI();

	}
	public void setUpGUI() {
		mainFrame = new JFrame("Musicmate");
		mainFrame.setVisible(true);
		Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();
		f_xpos = (int)(screen.getWidth() / 2 - f_wid/ 2);
		f_ypos = (int)(screen.getHeight() / 2 - f_hgt / 2);

		mainFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		mainFrame.setBounds(f_xpos-150, f_ypos-50, f_wid, f_hgt);

		mainPanel =  new MainPanel();
		mainPanel.setLayout(null);
		mainFrame.getContentPane().add(mainPanel);

		model = new DefaultTableModel(contents,header){
			public boolean isCellEditable(int c, int h) 	// 더블클릭시 수정이 안되게
			{
				if(h==0 || h==1 || h==2) return false;
				else return true;
			} 
		};
		mainT = new JTable(model);
		mainSC = new JScrollPane(mainT);
		mainSC.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS); // 수직바생성
		mainSC.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER); // 수평바생성
		mainT.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);			// 칼럼들 길이조절
		mainT.getColumnModel().getColumn(0).setPreferredWidth(40);
		mainT.getColumnModel().getColumn(1).setPreferredWidth(500);
		mainT.getColumnModel().getColumn(2).setPreferredWidth(200);	
		mainT.getColumnModel().getColumn(3).setPreferredWidth(60);
		mainT.getColumnModel().getColumn(4).setPreferredWidth(60); // 길이조절 끝
		mainT.getTableHeader().setResizingAllowed(false);				// 사용자가 길이 조정 못하게끔
		mainT.getTableHeader().setReorderingAllowed(false);				// 사용자가 칼럼 위치 못바꾸게
		DefaultTableCellRenderer dtcr = new DefaultTableCellRenderer();		// 데이터를 가운데정렬시키기
		dtcr.setHorizontalAlignment(SwingConstants.CENTER);
		TableColumnModel tcm = mainT.getColumnModel();
		for(int i=0; i< tcm.getColumnCount(); i++) 	tcm.getColumn(i).setCellRenderer(dtcr);		// 가운데정렬 끝	
		mainT.setRowHeight(40);
		//버튼 칼럼
		TableColumn buttonColumn1 = mainT.getColumnModel().getColumn(3);
		TableColumn buttonColumn2 = mainT.getColumnModel().getColumn(4);
		InfoButton infoB = new InfoButton();
		PlusButton plusB = new PlusButton();
		buttonColumn1.setCellRenderer(infoB);
		buttonColumn1.setCellEditor(infoB);
		buttonColumn2.setCellRenderer(plusB);
		buttonColumn2.setCellEditor(plusB);
		mainSC.setBounds(50,200, 880, 500);
		prepareList();
		mainPanel.add(mainSC);


		searchB = new JButton("검색");
		searchB.setBounds(830, 145, 60, 30);
		search = new JTextField(100);
		search.setBounds(130, 145, 690, 30);
		SearchListener s = new SearchListener();
		searchB.addActionListener(s);
		search.addActionListener(s);
		mainPanel.add(searchB);
		mainPanel.add(search);


		if(USER ==1) {
			adminB = new JButton("관리자모드");
			adminB.setBounds(840, 10, 105, 43);
			adminB.addActionListener(new AdminListener());
			mainPanel.add(adminB);
		}

		mainPanel.repaint();
		playFrame = new PlayListFrame(USER);		
	}

	//DB연결 메소드
	private void dbConnectionInit() 			 
	{
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver");					// JDBC드라이버를 JVM영역으로 가져오기
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/musicmate?serverTimezone=Asia/Seoul&useSSL=false", "root", "487875");	// DB 연결하기
			System.out.println("연결되었습니다");
		}
		catch (ClassNotFoundException cnfe) 
		{
			System.out.println("JDBC 드라이버 클래스를 찾을 수 없습니다 : " + cnfe.getMessage());
		}
		catch (Exception ex) 
		{
			System.out.println("DB 연결 에러 : " + ex.getMessage());
		}
	}



	//메인테이블 리스트
	public void prepareList() 
	{
		try 
		{
			Statement stmt = conn.createStatement();			// SQL 문을 작성을 위한  Statement 객체 생성
			// 현재 DB에 있는 내용 추출해서 노래목록을 songs 리스트에 출력하기
			ResultSet rs = stmt.executeQuery("SELECT m.제목, s.가수 FROM music m NATURAL JOIN singers s order by 좋아요 desc");
			String nameis,singeris,chartis;
			String[] move = new String[3];
			int rank =0;
			while (rs.next()) 
			{
				rank++;
				chartis = String.valueOf(rank);
				nameis = rs.getString("제목");
				singeris = rs.getString("가수");
				model.addRow(new Object[] {chartis,nameis,singeris,"정보","담기" });
			}
			stmt.close();										// statement는 사용후 닫는 습관
		} catch (SQLException sqlex) 
		{
			System.out.println("SQL 에러 : " + sqlex.getMessage());
			sqlex.printStackTrace();
		}
	}

	void info(int row) {
		song = (String)model.getValueAt(row, 1);
		//nowAlbum = song;
		JFrame infoFrame = new JFrame(song+" 정보");
		infoFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		infoFrame.setBounds(f_xpos+200, f_ypos+50, 500, 600);
		infoFrame.setVisible(true);

		InfoPanel infoPanel = new InfoPanel();
		infoPanel.setLayout(null);
		infoFrame.getContentPane().add(infoPanel);

		String lyric = "";
		String singer = "", date = "", genre = "";
		int like=0;
		try 
		{
			Statement stmt = conn.createStatement();			// SQL 문을 작성을 위한  Statement 객체 생성
			ResultSet rs = stmt.executeQuery("SELECT l.가사,s.가수,m.발매일,g.장르, m.좋아요  FROM music m NATURAL JOIN lyrics l natural join singers s natural join genre g where m.제목='"+song+"';");
			rs.next();
			lyric = rs.getString("l.가사");
			singer = rs.getString("s.가수");
			date = rs.getString("m.발매일");
			genre = rs.getString("g.장르");
			like = rs.getInt("m.좋아요");
			stmt.close();										// statement는 사용후 닫는 습관
		} catch (SQLException sqlex) 
		{
			System.out.println("SQL 에러 : " + sqlex.getMessage());
			sqlex.printStackTrace();
		}

		lyrics = new JTextArea(lyric,50,50);
		lyrics.setEditable(false);
		lyricSC = new JScrollPane(lyrics);
		lyricSC.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS); // 수직바생성
		lyricSC.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER); // 수평바생성
		lyricSC.setBounds(15, 250, 450, 300);
		infoPanel.add(lyricSC);

		JLabel songL = new JLabel("제목 : " +song);
		JLabel singerL = new JLabel("가수 : "+singer);
		JLabel dateL = new JLabel("발매일 : "+date);
		JLabel genreL = new JLabel("장르 : "+genre);
		likeL = new JLabel(""+like);
		songL.setBounds(220, 60, 200, 50);
		singerL.setBounds(220, 80, 200, 50);
		dateL.setBounds(220, 100, 200, 50);
		genreL.setBounds(220, 120, 200, 50);
		likeL.setBounds(260, 140, 70, 70);

		likeB = new JButton(new ImageIcon("src/Image/like.png"));
		like2B = new JButton(new ImageIcon("src/Image/like2.png"));
		likeB.setBounds(210, 150, 50, 50);
		like2B.setBounds(210, 150, 50, 50);
		likeB.setBorderPainted(false);likeB.setFocusPainted(false);likeB.setContentAreaFilled(false);
		like2B.setBorderPainted(false);like2B.setFocusPainted(false);like2B.setContentAreaFilled(false);
		likeB.setVisible(false);
		likeB.addActionListener(new LikeListener());
		like2B.addActionListener(new LikeListener2());

		infoPanel.add(songL);
		infoPanel.add(singerL);
		infoPanel.add(dateL);
		infoPanel.add(genreL);
		infoPanel.add(likeL);
		infoPanel.add(likeB);
		infoPanel.add(like2B);

	}

	//메인패널
	class MainPanel extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			g2d.setColor(Color.WHITE);
			g2d.fillRect(0, 0, f_wid, f_hgt);
			ImageIcon musicmate = new ImageIcon("src/Image/musicmate2.png");
			g2d.drawImage(musicmate.getImage(), 200,5, 600, 100, this);
			ImageIcon search = new ImageIcon("src/Image/search.png");
			g2d.drawImage(search.getImage(), 75,135, 50, 50, this);
		}
	}

	class InfoPanel extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			ImageIcon back = new ImageIcon("src/Image/info배경.png");
			g2d.drawImage(back.getImage(),-10,0, 500, 600, this);
			ImageIcon asd = new ImageIcon("src/album/"+nowAlbum+".png");
			g2d.drawImage(asd.getImage(),50,55, 150, 150, this);
		}
	}

	class LikeListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			int like=0;
			try 
			{
				Statement stmt = conn.createStatement();			// SQL 문을 작성을 위한  Statement 객체 생성
				stmt.executeUpdate("UPDATE music SET 좋아요 = 좋아요-1 WHERE 제목='"+song+"';");
				ResultSet rs = stmt.executeQuery("SELECT 좋아요 from music where 제목='"+song+"';");
				rs.next();
				like = rs.getInt("좋아요");
				stmt.close();										// statement는 사용후 닫는 습관
			} catch (SQLException sqlex) 
			{
				System.out.println("SQL 에러 : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
			likeL.setText(""+like);
			likeB.setVisible(false);
			like2B.setVisible(true);
		}

	}
	class LikeListener2 implements ActionListener{

		@Override
		public void actionPerformed(ActionEvent e) {
			int like=0;
			try 
			{
				Statement stmt = conn.createStatement();			// SQL 문을 작성을 위한  Statement 객체 생성
				stmt.executeUpdate("UPDATE music SET 좋아요 = 좋아요+1 WHERE 제목='"+song+"';");
				ResultSet rs = stmt.executeQuery("SELECT 좋아요 from music where 제목='"+song+"';");
				rs.next();
				like = rs.getInt("좋아요");
				stmt.close();										// statement는 사용후 닫는 습관
			} catch (SQLException sqlex) 
			{
				System.out.println("SQL 에러 : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
			likeL.setText(""+like);
			likeB.setVisible(true);
			like2B.setVisible(false);

		}

	}

	class SearchListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			String whatSearch = search.getText();
			if(whatSearch.compareTo("") == 0) {
				prepareList();
				return;
			}
			DefaultTableModel asd = (DefaultTableModel)mainT.getModel();
			asd.setNumRows(0);
			try 
			{
				Statement stmt = conn.createStatement();			// SQL 문을 작성을 위한  Statement 객체 생성
				// 현재 DB에 있는 내용 추출해서 노래목록을 songs 리스트에 출력하기
				ResultSet rs = stmt.executeQuery("SELECT m.제목, s.가수 FROM music m NATURAL JOIN singers s  WHERE m.제목 LIKE '%"
						+whatSearch+"%' order by 좋아요 desc;");
				String nameis,singeris,chartis;
				String[] move = new String[3];
				int rank =0;
				while (rs.next()) 
				{
					rank++;
					chartis = String.valueOf(rank);
					nameis = rs.getString("제목");
					singeris = rs.getString("가수");
					model.addRow(new Object[] {chartis,nameis,singeris,"정보","담기" });
				}
				stmt.close();										// statement는 사용후 닫는 습관
			} catch (SQLException sqlex) 
			{
				System.out.println("SQL 에러 : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
		}
	}
	class AdminListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			// DB에서 가져오는 데이터를 rowObjects의 형태로 저장하고 이들의 리스트를 Printer 또는 Preview로 보내 줌
			ArrayList<RowObjects> rowList = new ArrayList<RowObjects>();	// 행들의 리스트
			RowObjects line;												// 하나의 행
			PrintObject word;												// 하나의 단어
			try {
				Statement stmt = conn.createStatement();					// SQL 문장 만들기 위한 Statement 객체
				ResultSet rs = stmt.executeQuery("SELECT 회원번호, 이름, 아이디, 비밀번호, g.장르 FROM user natural join genre g");
				while(rs.next()) {
					line = new RowObjects();								// 5개의 단어가 1줄
					line.add(new PrintObject(rs.getString("회원번호"), 10));
					line.add(new PrintObject(rs.getString("이름"), 10));
					line.add(new PrintObject(rs.getString("아이디"), 20));
					line.add(new PrintObject(rs.getString("비밀번호"), 20));
					line.add(new PrintObject(rs.getString("g.장르"), 10));
					rowList.add(line);										// 출력해야 될 전체 리스트를 만듬									
				}
				
				stmt.close();

				// 각 페이지의 칼럼 헤더를 위해 한 줄 만들음
				line = new RowObjects();									// 5개의 단어가 1줄
				line.add(new PrintObject("회원번호", 10));
				line.add(new PrintObject("이름", 10));
				line.add(new PrintObject("아이디", 20));
				line.add(new PrintObject("비밀번호", 20));
				line.add(new PrintObject("장르", 10));



				Preview prv = new Preview(new PrintObject("회원리스트", 20), line, rowList, true);
				prv.preview();

			} catch (SQLException sqlex) {
				System.out.println("SQL 에러 : " + sqlex.getMessage());
				sqlex.printStackTrace();
			} catch (Exception ex) {
				System.out.println("DB Handling 에러(리스트 리스너) : " + ex.getMessage());
				ex.printStackTrace();
			}
		}



	}
	//테이블 버튼사용
	//정보버튼
	class InfoButton extends AbstractCellEditor implements TableCellEditor, TableCellRenderer
	{
		public Component getTableCellRendererComponent(JTable table, Object value, boolean selected, boolean focus, final int row, final int column)
		{
			JButton button = null;
			button = new JButton(new ImageIcon("src/Image/infoO.png"));
			button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);

			button.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{
					System.out.println(model.getValueAt(row, 1));
				}
			});
			return button;
		}
		public Component getTableCellEditorComponent(JTable table, Object value, boolean selected, int row, int column)
		{
			JButton button = null;

			button = new JButton(new ImageIcon("src/Image/infoO.png"));
			button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
			button.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{
					info(row);
				}
			});

			return button;
		}
		@Override
		public Object getCellEditorValue() {
			// TODO Auto-generated method stub
			return null;
		}
	}
	//담기 버튼
	class PlusButton extends AbstractCellEditor implements TableCellEditor, TableCellRenderer
	{
		public Component getTableCellRendererComponent(JTable table, Object value, boolean selected, boolean focus, final int row, final int column)
		{
			JButton button = null;

			{
				button = new JButton(new ImageIcon("src/Image/addB.png"));
				button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
				button.addActionListener(new ActionListener()
				{
					public void actionPerformed(ActionEvent e)
					{

					}
				}); 
			}
			return button;
		}
		public Component getTableCellEditorComponent(JTable table, Object value, boolean selected, int row, int column)
		{
			JButton button = null;
			{
				button = new JButton(new ImageIcon("src/Image/addB.png"));
				button.setBorderPainted(false);button.setFocusPainted(false);button.setContentAreaFilled(false);
				button.addActionListener(new ActionListener()
				{
					public void actionPerformed(ActionEvent e)
					{
						try 
						{
							String a = (String)model.getValueAt(row, 1);
							Statement stmt = conn.createStatement();			
							stmt.executeUpdate("INSERT INTO playlist"+USER+"(노래번호) SELECT 노래번호 FROM music WHERE 제목='"+a+"';");
							stmt.close();										// statement는 사용후 닫는 습관
							playFrame.prepareList();
						} catch (SQLException sqlex) 
						{
							System.out.println("SQL 에러 : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
					}
				});
			}
			return button;
		}
		@Override
		public Object getCellEditorValue() {
			return null;
		}
	}
}

