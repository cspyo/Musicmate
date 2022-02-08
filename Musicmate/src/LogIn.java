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

	Connection conn; // DB ���� Connection ��ü��������
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
		lFrame = new JFrame("�α���");
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
		lButton = new JButton("�α���");
		signUpButton = new JButton("ȸ������");
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

	//DB���� �޼ҵ�
	private void dbConnectionInit() 			 
	{
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver");					// JDBC����̹��� JVM�������� ��������
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/musicmate?serverTimezone=Asia/Seoul&useSSL=false", "root", "487875");	// DB �����ϱ�
			System.out.println("����Ǿ����ϴ�");
		}
		catch (ClassNotFoundException cnfe) 
		{
			System.out.println("JDBC ����̹� Ŭ������ ã�� �� �����ϴ� : " + cnfe.getMessage());
		}
		catch (Exception ex) 
		{
			System.out.println("DB ���� ���� : " + ex.getMessage());
		}
	}

	//����
	public void error(String errorCode) {
		errorFrame = new JFrame(errorCode);
		errorFrame.setVisible(true);
		errorPanel = new ErrorPanel();
		errorFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		errorFrame.setResizable(false);
		errorFrame.setBounds(650, 310, 300, 200);
		errorFrame.getContentPane().add(errorPanel);
	}

	//�α��� ��ư ������
	public class LoginBListener implements ActionListener 
	{
		public void actionPerformed (ActionEvent e) 
		{
			loginB = true;
			id = idField.getText();
			pw = pwField.getText();

			//���̵� �˻�
			try
			{
				Statement stmt = conn.createStatement();				
				ResultSet rs = stmt.executeQuery("SELECT ȸ����ȣ,���̵� FROM user");
				while (rs.next()) 
				{
					if(id.compareTo(rs.getString("���̵�")) == 0)
					{
						idexist = true;
						user = rs.getInt("ȸ����ȣ");
						break;
					}
				}
				stmt.close();
			}
			catch (SQLException sqlex) 
			{
				System.out.println("SQL ���� : " + sqlex.getMessage());
				sqlex.printStackTrace();
			}
			//��й�ȣ �˻�
			if(idexist == true)
			{
				try
				{
					Statement stmt = conn.createStatement();				
					ResultSet rs = stmt.executeQuery("SELECT ��й�ȣ FROM user");
					while (rs.next()) 
					{
						if(pw.compareTo(rs.getString("��й�ȣ")) == 0)
						{
							pwexist = true;
							break;
						}
					}
					stmt.close();
				}
				catch (SQLException sqlex) 
				{
					System.out.println("SQL ���� : " + sqlex.getMessage());
					sqlex.printStackTrace();
				}
			}

			if(idexist == true && pwexist == true) //�α��� ����
			{
				gomain = new MainFrame(user);
				lFrame.setVisible(false);
				gomain.go();
			}
			else if(idexist == true && pwexist == false) //��� Ʋ��
			{
				error("��й�ȣ����!!!");
			}
			else if(idexist == false)  //���̵� Ʋ��
			{
				error("���̵����!!!");
			}
		}
	}

	//ȸ������ ��ư ������
	public class SignUpBListener implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			signUpFrame = new JFrame("ȸ������");
			signUpFrame.setBounds(f_xpos-150, f_ypos-150, 400, 300);
			signUpFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
			signUpFrame.setVisible(true);

			SignUpPanel sPanel = new SignUpPanel();
			sPanel.setLayout(new RiverLayout());
			nameField = new JTextField(20);
			sIdField = new JTextField(20);
			sPwField = new JPasswordField(20);
			sPanel.add("br",Box.createRigidArea(new Dimension(0,60)));
			sPanel.add("p left", new JLabel("��  ��"));
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
			sPanel.add("br", new JLabel("��ȣ �帣"));
			sPanel.add("tab",genreCh);

			closeB = new JButton("�ݱ�");
			completeB = new JButton("�Ϸ�");
			sPanel.add("br",Box.createRigidArea(new Dimension(0,20)));
			sPanel.add("br center",completeB);
			sPanel.add("center", closeB);
			closeB.addActionListener(new CloseBListener());
			completeB.addActionListener(new CompleteBListener());

			signUpFrame.getContentPane().add(sPanel);
		}

	}

	//�Ϸ� ��ư ������
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
				error("����");
			}
			else
			{
				try
				{
					Statement stmt = conn.createStatement();				
					ResultSet rs = stmt.executeQuery("SELECT �̸� FROM user");
					while (rs.next()) 
					{
						if(tmpname.compareTo(rs.getString("�̸�")) == 0)
						{
							overlapname = true;
							break;
						}
					}
					stmt.close();
				}
				catch (SQLException sqlex) 
				{
					System.out.println("SQL ���� : " + sqlex.getMessage());
					sqlex.printStackTrace();
				}
				if(overlapname == true)
				{
					error("�̸���������");
				}
				else
				{
					try
					{
						Statement stmt = conn.createStatement();				
						ResultSet rs = stmt.executeQuery("SELECT ���̵�  FROM user");
						while (rs.next()) 
						{
							if(tmpid.compareTo(rs.getString("���̵�")) == 0)
							{
								overlapid = true;
								break;
							}
						}
						stmt.close();
					}
					catch (SQLException sqlex) 
					{
						System.out.println("SQL ���� : " + sqlex.getMessage());
						sqlex.printStackTrace();
					}
					if(overlapid == true)
					{
						error("���̵��������");

					}
					else
					{
						try
						{
							Statement stmt = conn.createStatement();				
							stmt.executeUpdate("INSERT INTO user (���̵�,��й�ȣ,�̸�,�帣��ȣ)"
									+ "VALUES('"+tmpid+"','"+tmppw+"','"+tmpname+"',"+genreNum+")");
							stmt.close();

						}
						catch (SQLException sqlex) 
						{
							System.out.println("SQL ���� : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
						try
						{
							Statement stmt = conn.createStatement();				
							ResultSet rs = stmt.executeQuery("SELECT ȸ����ȣ FROM user");
							while(rs.next())
							{
								if(max < rs.getInt("ȸ����ȣ")) max = rs.getInt("ȸ����ȣ");
							}
							stmt.close();
						}
						catch (SQLException sqlex) 
						{
							System.out.println("SQL ���� : " + sqlex.getMessage());
							sqlex.printStackTrace();
						}
						try
						{
							Statement stmt = conn.createStatement();				
							stmt.executeUpdate("CREATE TABLE playlist"+max+"("
									+ "���� INT NOT NULL AUTO_INCREMENT PRIMARY KEY,"
									+ "�뷡��ȣ INT, FOREIGN KEY(�뷡��ȣ) REFERENCES music(�뷡��ȣ))");
							stmt.close();

						}
						catch (SQLException sqlex) 
						{
							System.out.println("SQL ���� : " + sqlex.getMessage());
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
	
	//���� �г�
	public class ErrorPanel extends JPanel
	{
		public void paintComponent(Graphics g)
		{
			Graphics2D g2d = (Graphics2D) g;
			ImageIcon lback = new ImageIcon("src/Image/�������.png");//��ٰܹ�ü����
			g2d.drawImage(lback.getImage(), 0, 0, this.getWidth(), this.getHeight(), this);
			g2d.setColor(Color.WHITE);
			g2d.setFont(new Font("����",Font.BOLD, 20));

			if(empty == true)
			{
				g2d.drawString("��� ������ �Է����ֽʽÿ�.", 5, 120);
				empty = false;
			}
			else
			{
				if(loginB == true)
				{
					if(idexist == false) 
					{
						g2d.drawString("���̵� �������� �ʽ��ϴ�.", 5, 120);
						pwexist = false;
					}
					else if(idexist == true && pwexist == false)
					{
						g2d.drawString("��й�ȣ�� Ʋ���ϴ�.", 5, 120);
						idexist = false;
					}
				}
				else
				{
					if(overlapname == true)
					{
						g2d.drawString("ȸ������ ���ԵǾ� �ֽ��ϴ�.", 8, 120);
						overlapname = false;
					}
					else if(overlapid == true) 
					{
						g2d.drawString("������ ���̵� �����մϴ�.", 8, 120);
						overlapid = false;
					}
				}

			}
		}
	}
	
	public class SignUpPanel extends JPanel{
		public void paintComponent(Graphics g) {
			Graphics2D g2d = (Graphics2D) g;
			ImageIcon sBack = new ImageIcon("src/Image/ȸ�����Թ��.png");
			g2d.drawImage(sBack.getImage(), 0,0,this.getWidth(),this.getHeight(),null);
		}
	}
}
