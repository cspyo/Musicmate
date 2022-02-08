import java.awt.BorderLayout;
import java.awt.Choice;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.Box;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;


import se.datadosen.component.RiverLayout;

public class LogIn {

	Connection conn; // DB 연결 Connection 객체참조변수
	JFrame lFrame, signUpFrame, errorFrame;
	ErrorPanel errorPanel;
	JButton lButton, signUpButton,closeB, completeB;
	JTextField idField, nameField, sIdField;
	JPasswordField pwField, sPwField;
	Choice genreCh;
	MainFrame gomain;
	int f_xpos, f_ypos;
	int lf_width = 400;
	int lf_height = 300;
	int genreNum=1;

	boolean idexist = false, pwexist = false, overlapid = false, loginB = false, empty = false, overlapname=false;
	String id,pw;
	int user, max=0;

	public LogIn() {
		dbConnectionInit();
		lFrame = new JFrame("로그인");
		lFrame.setVisible(true);
		Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();
		f_xpos = (int)(screen.getWidth() / 2 - lf_width/ 2);
		f_ypos = (int)(screen.getHeight() / 2 - lf_height / 2);

		lFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		lFrame.setBounds(f_xpos-150, f_ypos-150, lf_width, lf_height);

		JPanel middlePanel = new JPanel(new RiverLayout());
		idField = new JTextField(20);
		pwField = new JPasswordField(20);
		middlePanel.setBackground(Color.WHITE);
		middlePanel.add("p left",new JLabel("I      D"));
		middlePanel.add("tab", idField);
		middlePanel.add("br",Box.createRigidArea(new Dimension(0,8)));
		middlePanel.add("br", new JLabel("PassWord"));
		middlePanel.add("tab", pwField);

		JPanel bottomPanel = new JPanel(new RiverLayout());
		bottomPanel.setBackground(Color.WHITE);
		JPanel tmpPanel = new JPanel(new RiverLayout());
		tmpPanel.setBackground(Color.WHITE);
		lButton = new JButton("로그인");
		signUpButton = new JButton("회원가입");
		tmpPanel.add(lButton);
		tmpPanel.add("tab", signUpButton);
		bottomPanel.add("br", Box.createRigidArea(new Dimension(0,10)));
		bottomPanel.add("br center", tmpPanel);


		JPanel mainPanel = new JPanel(new GridLayout(3,1));
		mainPanel.add(new JPanel() {
			public void paintComponent(Graphics g)
			{
				Graphics2D g2d = (Graphics2D) g;
				ImageIcon lback = new ImageIcon("src/Image/musicmate.png");
				g2d.drawImage(lback.getImage(), 0, 0, 385, 100, this);
			}

		},BorderLayout.NORTH);
		mainPanel.add(middlePanel,BorderLayout.CENTER);
		mainPanel.add(bottomPanel,BorderLayout.SOUTH);

		LoginBListener a =new LoginBListener();
		lButton.addActionListener(a);
		pwField.addActionListener(a);
		signUpButton.addActionListener(new SignUpBListener());

		//lFrame.setResizable(false);

		lFrame.getContentPane().add(mainPanel);
		mainPanel.repaint();
		

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

	//에러
	public void error(String errorCode) {
		errorFrame = new JFrame(errorCode);
		errorFrame.setVisible(true);
		errorPanel = new ErrorPanel();
		errorFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		errorFrame.setResizable(false);
		errorFrame.setBounds(650, 310, 300, 200);
		errorFrame.getContentPane().add(errorPanel);
	}

	//로그인 버튼 리스너
	public class LoginBListener implements ActionListener 
	{
		public void actionPerformed (ActionEvent e) 
		{
			loginB = true;
			id = idField.getText();
			pw = pwField.getText();

			//아이디 검사
			try
			{
				Statement stmt = conn.createStatement();				
				ResultSet rs = stmt.executeQuery("SELECT 회원번호,아이디 FROM user");
				while (rs.next()) 
				{
					if(id.compareTo(rs.getString("아이디")) == 0)
					{
						idexist = true;
						user = rs.getInt("회원번호");
						break;
					}
				}
				stmt.close();
			}
			catch (SQLException sqlex) 
			{
				System.out.println("SQL 에러 : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
			//비밀번호 검사
			if(idexist == true)
			{
				try
				{
					Statement stmt = conn.createStatement();				
					ResultSet rs = stmt.executeQuery("SELECT 비밀번호 FROM user");
					while (rs.next()) 
					{
						if(pw.compareTo(rs.getString("비밀번호")) == 0)
						{
							pwexist = true;
							break;
						}
					}
					stmt.close();
				}
				catch (SQLException sqlex) 
				{
					System.out.println("SQL 에러 : " + sqlex.getMessage());
					sqlex.printStackTrace();
				}
			}

			if(idexist == true && pwexist == true) //로그인 성공
			{
				gomain = new MainFrame(user);
				lFrame.setVisible(false);
				gomain.go();
			}
			else if(idexist == true && pwexist == false) //비번 틀림
			{
				error("비밀번호오류!!!");
			}
			else if(idexist == false)  //아이디 틀림
			{
				error("아이디오류!!!");
			}
		}
	}

	//회원가입 버튼 리스너
	public class SignUpBListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			signUpFrame = new JFrame("회원가입");
			signUpFrame.setBounds(f_xpos-150, f_ypos-150, 400, 300);
			signUpFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
			signUpFrame.setVisible(true);

			SignUpPanel sPanel = new SignUpPanel();
			sPanel.setLayout(new RiverLayout());
			nameField = new JTextField(20);
			sIdField = new JTextField(20);
			sPwField = new JPasswordField(20);
			sPanel.add("br",Box.createRigidArea(new Dimension(0,60)));
			sPanel.add("p left", new JLabel("이  름"));
			sPanel.add("tab", nameField);
			sPanel.add("br", new JLabel("I  D"));
			sPanel.add("tab", sIdField);
			sPanel.add("br", new JLabel("PassWord"));
			sPanel.add("tab", sPwField);

			genreCh = new Choice();
			genreCh.addItem("Ballad");
			genreCh.addItem("Dance");
			genreCh.addItem("Indi");
			genreCh.addItem("OST");
			genreCh.addItem("R&B");
			genreCh.addItem("Rap");
			genreCh.addItem("Rock");
			genreCh.addItemListener(new ItemListener()
			{
				public void itemStateChanged(ItemEvent e) 
				{
					if(e.getItem() == "Ballad") genreNum = 1;
					if(e.getItem() == "Dance") genreNum = 2;
					if(e.getItem() == "Indi") genreNum = 3;
					if(e.getItem() == "OST") genreNum = 4;
					if(e.getItem() == "R&B") genreNum = 5;
					if(e.getItem() == "Rap") genreNum = 6;
					if(e.getItem() == "Rock") genreNum = 7;
				}
			});
			genreCh.select(0);
			sPanel.add("br", new JLabel("선호 장르"));
			sPanel.add("tab",genreCh);

			closeB = new JButton("닫기");
			completeB = new JButton("완료");
			sPanel.add("br",Box.createRigidArea(new Dimension(0,20)));
			sPanel.add("br center",completeB);
			sPanel.add("center", closeB);
			closeB.addActionListener(new CloseBListener());
			completeB.addActionListener(new CompleteBListener());

			signUpFrame.getContentPane().add(sPanel);
		}

	}

	//완료 버튼 리스너
	public class CompleteBListener implements ActionListener 
	{
		public void actionPerformed (ActionEvent e) 
		{
			loginB = false;
			String tmpid = sIdField.getText();
			String tmppw = sPwField.getText();
			String tmpname = nameField.getText();
			if(tmpid.compareTo("") == 0) empty = true;
			if(tmppw.compareTo("") == 0) empty = true;
			if(tmpname.compareTo("") == 0) empty = true;
			if(empty == true)
			{
				error("오류");
			}
			else
			{
				try
				{
					Statement stmt = conn.createStatement();				
					ResultSet rs = stmt.executeQuery("SELECT 이름 FROM user");
					while (rs.next()) 
					{
						if(tmpname.compareTo(rs.getString("이름")) == 0)
						{
							overlapname = true;
							break;
						}
					}
					stmt.close();
				}
				catch (SQLException sqlex) 
				{
					System.out.println("SQL 에러 : " + sqlex.getMessage());
					sqlex.printStackTrace();
				}
				if(overlapname == true)
				{
					error("이름생성오류");
				}
				else
				{
					try
					{
						Statement stmt = conn.createStatement();				
						ResultSet rs = stmt.executeQuery("SELECT 아이디  FROM user");
						while (rs.next()) 
						{
							if(tmpid.compareTo(rs.getString("아이디")) == 0)
							{
								overlapid = true;
								break;
							}
						}
						stmt.close();
					}
					catch (SQLException sqlex) 
					{
						System.out.println("SQL 에러 : " + sqlex.getMessage());
						sqlex.printStackTrace();
					}
					if(overlapid == true)
					{
						error("아이디생성오류");

					}
					else
					{
						try
						{
							Statement stmt = conn.createStatement();				
							stmt.executeUpdate("INSERT INTO user (아이디,비밀번호,이름,장르번호)"
									+ "VALUES('"+tmpid+"','"+tmppw+"','"+tmpname+"',"+genreNum+")");
							stmt.close();

						}
						catch (SQLException sqlex) 
						{
							System.out.println("SQL 에러 : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
						try
						{
							Statement stmt = conn.createStatement();				
							ResultSet rs = stmt.executeQuery("SELECT 회원번호 FROM user");
							while(rs.next())
							{
								if(max < rs.getInt("회원번호")) max = rs.getInt("회원번호");
							}
							stmt.close();
						}
						catch (SQLException sqlex) 
						{
							System.out.println("SQL 에러 : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
						try
						{
							Statement stmt = conn.createStatement();				
							stmt.executeUpdate("CREATE TABLE playlist"+max+"("
									+ "순서 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,"
									+ "노래번호 INT, FOREIGN KEY(노래번호) REFERENCES music(노래번호))");
							stmt.close();

						}
						catch (SQLException sqlex) 
						{
							System.out.println("SQL 에러 : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
						signUpFrame.setVisible(false);
					}
				}
			}
		}
	}

	class CloseBListener implements ActionListener{

		@Override
		public void actionPerformed(ActionEvent e) {
			signUpFrame.setVisible(false);
		}
	}
	
	//오류 패널
	public class ErrorPanel extends JPanel
	{
		public void paintComponent(Graphics g)
		{
			Graphics2D g2d = (Graphics2D) g;
			ImageIcon lback = new ImageIcon("src/Image/오류배경.png");//상단바객체생성
			g2d.drawImage(lback.getImage(), 0, 0, this.getWidth(), this.getHeight(), this);
			g2d.setColor(Color.WHITE);
			g2d.setFont(new Font("어허",Font.BOLD, 20));

			if(empty == true)
			{
				g2d.drawString("모든 정보를 입력해주십시오.", 5, 120);
				empty = false;
			}
			else
			{
				if(loginB == true)
				{
					if(idexist == false) 
					{
						g2d.drawString("아이디가 존재하지 않습니다.", 5, 120);
						pwexist = false;
					}
					else if(idexist == true && pwexist == false)
					{
						g2d.drawString("비밀번호가 틀립니다.", 5, 120);
						idexist = false;
					}
				}
				else
				{
					if(overlapname == true)
					{
						g2d.drawString("회원님은 가입되어 있습니다.", 8, 120);
						overlapname = false;
					}
					else if(overlapid == true) 
					{
						g2d.drawString("동일한 아이디가 존재합니다.", 8, 120);
						overlapid = false;
					}
				}

			}
		}
	}
	
	public class SignUpPanel extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			ImageIcon sBack = new ImageIcon("src/Image/회원가입배경.png");
			g2d.drawImage(sBack.getImage(), 0,0,this.getWidth(),this.getHeight(),null);
		}
	}
}
